#!/usr/bin/env bash

# Import `record_image_failure` function
source ../common.sh

# buildah bud --registries-conf=registries.conf -f "etb-all-clients.Dockerfile" -t "etb-all-clients:latest" --format docker
buildah bud --registries-conf=registries.conf -f "etb-all-clients_inst.Dockerfile" -t "etb-all-clients:latest-inst" --format docker || record_image_failure "etb-all-clients:latest-inst"
podman tag localhost/etb-all-clients:latest-inst us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:inst
