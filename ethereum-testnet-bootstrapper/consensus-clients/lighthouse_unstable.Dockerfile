FROM etb-client-builder:latest as base 

WORKDIR /git

from base as builder

RUN git clone https://github.com/sigp/lighthouse.git && cd lighthouse && git checkout unstable

RUN cd lighthouse && make 

from debian:bullseye-slim

COPY --from=builder /usr/local/cargo/bin/lighthouse /usr/local/bin/lighthouse

ENTRYPOINT ["/bin/bash"]
