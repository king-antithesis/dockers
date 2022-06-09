#!/usr/bin/env bash

for df in $(ls | grep 'inst.Dockerfile\|master.Dockerfile'); do
    echo $df
    i=`echo $df | tr '_' ':'`
    image=`echo "${i::-11}"`
    buildah bud --registries-conf=registries.conf -f "${df}" -t "${image}" --format docker
    #BUILDKIT=1 docker build -f "$df" -t "${i::-11}" .
done

# buildah bud --registries-conf=registries.conf -f "prysm_develop-inst.Dockerfile" -t "prysm:develop-inst" --format docker
# buildah bud --registries-conf=registries.conf -f "nimbus_kiln-dev-auth-inst.Dockerfile" -t "nimbus:kiln-dev-auth-inst" --format docker
# buildah bud --registries-conf=registries.conf -f "nimbus_kiln-dev-auth.Dockerfile" -t "nimbus:kiln-dev-auth" --format docker
# buildah bud --registries-conf=registries.conf -f "prysm_develop-inst.Dockerfile" -t "prysm:develop-inst" --format docker