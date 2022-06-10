#!/usr/bin/env bash

# Import `record_image_failure` function
source ../common.sh

./buildah-tx-fuzzer.sh

#BUILDKIT=1 docker build -t geth:bad-block-creator -f geth_bad-block-creator.Dockerfile .
buildah bud --registries-conf=registries.conf -f "geth_bad-block-creator.Dockerfile" -t "geth:bad-block-creator" --format docker || record_image_failure "geth:bad-block-creator"
buildah bud --registries-conf=registries.conf -f "geth_bad-block-creator-inst.Dockerfile" -t "geth:bad-block-creator-inst" --format docker || record_image_failure "geth:bad-block-creator-inst"
