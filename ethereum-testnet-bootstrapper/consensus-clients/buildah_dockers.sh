#!/usr/bin/env bash

# Import `record_image_failure` function
source ../common.sh

for df in $(ls | grep 'inst.Dockerfile\|master.Dockerfile'); do
    echo $df
    i=`echo $df | tr '_' ':'`
    image=`echo "${i::-11}"`
    buildah bud --registries-conf=registries.conf -f "${df}" -t "${image}" --format docker || record_image_failure "${image}"
    #BUILDKIT=1 docker build -f "$df" -t "${i::-11}" .
done

# buildah bud --registries-conf=registries.conf -f "prysm_develop-inst.Dockerfile" -t "prysm:develop-inst" --format docker
# buildah bud --registries-conf=registries.conf -f "nimbus_kiln-dev-auth-inst.Dockerfile" -t "nimbus:kiln-dev-auth-inst" --format docker
# buildah bud --registries-conf=registries.conf -f "lighthouse_unstable-inst.Dockerfile" -t "lighthouse:unstable-inst" --format docker
# buildah bud --registries-conf=registries.conf -f "lodestar_master.Dockerfile" -t "lodestar:master" --format docker
