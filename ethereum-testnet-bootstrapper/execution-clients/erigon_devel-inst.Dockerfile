from etb-client-builder:latest as builder

# requires go 1.18
run rm /usr/local/bin/gofmt
run rm /usr/local/bin/go
run rm -r /usr/local/go

RUN wget https://go.dev/dl/go1.18.linux-amd64.tar.gz
RUN tar -zxvf go1.18.linux-amd64.tar.gz -C /usr/local/
RUN ln -s /usr/local/go/bin/go /usr/local/bin/go
RUN ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

workdir /git

arg erigon_branch="devel"

run mkdir -p /build

run git clone https://github.com/ledgerwatch/erigon.git

run cd erigon \
    && git checkout ${erigon_branch} \
    && git submodule update --init

# add items to this exclusions list to exclude them from instrumentation
RUN touch /opt/antithesis/go_instrumentation/exclusions.txt

# Antithesis -------------------------------------------------
WORKDIR /git
RUN mkdir -p erigon_instrumented && LD_LIBRARY_PATH=/opt/antithesis/go_instrumentation/lib /opt/antithesis/go_instrumentation/bin/goinstrumentor -antithesis=/opt/antithesis/go_instrumentation/instrumentation/go/wrappers/ -exclude=/opt/antithesis/go_instrumentation/exclusions.txt -stderrthreshold=INFO erigon erigon_instrumented
RUN cp -r erigon_instrumented/customer/* erigon/
RUN cd erigon && go mod edit -require=antithesis.com/instrumentation/wrappers@v1.0.0 -replace antithesis.com/instrumentation/wrappers=/opt/antithesis/go_instrumentation/instrumentation/go/wrappers 
# Antithesis -------------------------------------------------
# Get dependencies
RUN cd /git/erigon/ && go get -t -d ./...

run cd erigon/ \
    && CGO_CFLAGS="-I/opt/antithesis/go_instrumentation/include" CGO_LDFLAGS="-L/opt/antithesis/go_instrumentation/lib" make erigon

# cd ./cmd/erigon && CGO_CFLAGS="-I/opt/antithesis/go_instrumentation/include  -DMDBX_FORCE_ASSERTIONS=1 " go build -trimpath -tags nosqlite,noboltdb -buildvcs=false -ldflags "-X github.com/ledgerwatch/erigon/params.GitCommit=e02c77bf5a24a936d21960c303185e69147a20d7 -X github.com/ledgerwatch/erigon/params.GitBranch=devel -X github.com/ledgerwatch/erigon/params.GitTag=v2022.05.03 -X /opt/antithesis/go_instrumentation/lib" -o /git/erigon/build/bin/erigon


FROM etb-client-runner

copy --from=builder /git/erigon/build/bin/erigon /usr/local/bin/erigon
# COPY --from=builder /git/erigon_instrumented/symbols/* /opt/antithesis/symbols/

ENTRYPOINT ["/bin/bash"]
