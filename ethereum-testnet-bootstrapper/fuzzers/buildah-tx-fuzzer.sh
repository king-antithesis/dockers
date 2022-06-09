#!/usr/bin/env bash

# git clone -b develop https://github.com/kurtosis-tech/tx-fuzz
# git clone -b master https://github.com/MariusVanDerWijden/tx-fuzz
# cd tx-fuzz && git checkout 9b820ba578f6867b78c2068f47f0c1bcc72a2a39 && cd ../
git clone -b develop https://github.com/king-antithesis/tx-fuzz.git

cp registries.conf tx-fuzz/registries.conf
cp tx-fuzzer.Dockerfile tx-fuzz/tx-fuzzer.Dockerfile

# cd tx-fuzz && docker build -t tx-fuzzer -f tx-fuzzer.Dockerfile .
cd tx-fuzz && buildah bud --registries-conf=registries.conf -f "tx-fuzzer.Dockerfile" -t "tx-fuzzer" --format docker

cd ../

rm -rf tx-fuzz
