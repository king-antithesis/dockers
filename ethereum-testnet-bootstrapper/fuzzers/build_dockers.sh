#!/bin/bash

./build-tx-fuzzer.sh

BUILDKIT=1 docker build -t geth:bad-block-creator -f geth_bad-block-creator.Dockerfile .
BUILDKIT=1 docker build -t geth:bad-block-creator-inst -f geth_bad-block-creator-inst.Dockerfile .
