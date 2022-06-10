#!/usr/bin/env bash
# build the base-images (note not needed since they pull from z3nchada/<>) uncomment to update them.

export FAILED_IMAGES_LOG=`pwd`/failed_images.log
echo -n > $FAILED_IMAGES_LOG
# Import `record_image_failure` function
source ./common.sh

cd base-images

buildah bud --registries-conf=registries.conf -f "etb-client-builder.Dockerfile" -t "etb-client-builder" --format docker || record_image_failure "etb-client-builder"
podman tag localhost/etb-client-builder:latest docker.io/z3nchada/etb-client-builder:latest
# docker build -t etb-client-builder -f etb-client-builder.Dockerfile .
buildah bud --registries-conf=registries.conf -f "etb-client-runner.Dockerfile" -t "etb-client-runner" --format docker || record_image_failure "etb-client-runner"
podman tag localhost/etb-client-runner:latest docker.io/z3nchada/etb-client-runner:latest
# docker build -t etb-client-runner -f etb-client-runner.Dockerfile .

cd ../

# next build the fuzzers

cd fuzzers

./buildah_dockers.sh

cd ../

# next build the execution-clients and consensus clients.

cd execution-clients

echo "Building execution clients"

./buildah_dockers.sh

cd ../

cd consensus-clients

echo "Building consensus-clients"

./buildah_dockers.sh

cd ../

# now that we have all the prereqs build the etb-client images.

cd etb-clients

# buildah bud --registries-conf=registries.conf -f "etb-all-clients.Dockerfile" -t "etb-all-clients:latest" --format docker
#docker build -t etb-all-clients:latest -f etb-all-clients.Dockerfile
buildah bud --registries-conf=registries.conf -f "etb-all-clients_inst.Dockerfile" -t "etb-all-clients:latest-inst" --format docker || record_image_failure "etb-all-clients:latest-inst"
#docker build -t etb-all-clients:latest-inst -f etb-all-clients_inst.Dockerfile

cd ../

# lastly we can go ahead and build the ethereum-testnet-boostrapper

# mkdir tmp
#
# cd tmp
#
# git clone git@github.com:z3n-chada/ethereum-testnet-bootstrapper.git
#
# cd ethereum-testnet-boostrapper
#
# make build-bootstrapper
#
# cd ../../
#
# rm -rf tmp

# Check if log contains entries
if [ -s $FAILED_IMAGES_LOG ]; then
	printf "\n\n"
	echo "The following images failed to build:"
	cat $FAILED_IMAGES_LOG
	printf "\n\n"
else
	rm $FAILED_IMAGES_LOG
fi

printf "\n\nYou can now push this image with the following commands:\n"
echo "podman tag localhost/etb-all-clients:latest-inst us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:inst"
echo "customer credentials.shell.registry"
echo "podman push us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:inst"
