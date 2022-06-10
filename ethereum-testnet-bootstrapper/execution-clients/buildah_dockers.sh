#!/usr/bin/env bash

# Import `record_image_failure` function
source ../common.sh

for df in $(ls | grep Dockerfile); do
    i=`echo $df | tr '_' ':'`
    image=`echo "${i::-11}"`
    # BUILDKIT=1 docker build -f "$df" -t "$image" . &
    buildah bud --registries-conf=registries.conf -f "${df}" -t "${image}" --format docker || record_image_failure "${image}"
done


# geth_master-inst.Dockerfile
# buildah bud --registries-conf=registries.conf -f "geth_master-inst.Dockerfile" -t "geth:master-inst" --format docker
# erigon_devel-inst.Dockerfile
# buildah bud --registries-conf=registries.conf -f "erigon_devel-inst.Dockerfile" -t "erigon:devel-inst" --format docker
