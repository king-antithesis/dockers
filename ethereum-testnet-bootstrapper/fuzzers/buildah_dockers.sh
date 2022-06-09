#!/usr/bin/env bash

./buildah-tx-fuzzer.sh

#BUILDKIT=1 docker build -t geth:bad-block-creator -f geth_bad-block-creator.Dockerfile .
buildah bud --registries-conf=registries.conf -f "geth_bad-block-creator.Dockerfile" -t "geth:bad-block-creator" --format docker
buildah bud --registries-conf=registries.conf -f "geth_bad-block-creator-inst.Dockerfile" -t "geth:bad-block-creator-inst" --format docker
