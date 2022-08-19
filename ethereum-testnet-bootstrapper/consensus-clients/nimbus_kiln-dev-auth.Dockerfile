FROM z3nchada/etb-client-builder:latest as builder

WORKDIR /git
# ARG BRANCH="unstable"
ARG BRANCH="jsonnode-not-nil"

RUN ./llvm.sh 14
ENV LLVM_CONFIG=llvm-config-14

ARG NIMFLAGS="-d:disableMarchNative --cc:clang --clang.exe:clang-14 --clang.linkerexe:clang-14"

RUN git clone https://github.com/status-im/nimbus-eth2.git

RUN cd nimbus-eth2 && git checkout ${BRANCH}


RUN cd nimbus-eth2 && make nimbus_beacon_node NIMFLAGS="${NIMFLAGS}" \
                   && make nimbus_validator_client NIMFLAGS="${NIMFLAGS}"

RUN cd nimbus-eth2 && git log -n 1 --format=format:"%H" > /nimbus.version
from z3nchada/etb-client-runner:latest

COPY --from=builder /git/nimbus-eth2/build/nimbus_beacon_node /usr/local/bin/nimbus_beacon_node
COPY --from=builder /git/nimbus-eth2/build/nimbus_validator_client /usr/local/bin/nimbus_validator_client
COPY --from=builder /nimbus.version /nimbus.version
