#!/usr/bin/env bash
# build the base-images (note not needed since they pull from z3nchada/<>) uncomment to update them.

export FAILED_IMAGES_LOG=`pwd`/failed_images.log
echo -n > $FAILED_IMAGES_LOG
# Import `record_image_failure` function
source ./common.sh

cd base-images

buildah bud --registries-conf=registries.conf -f "etb-client-builder.Dockerfile" -t "etb-client-builder" --format docker || record_image_failure "etb-client-builder"
podman tag localhost/etb-client-builder:latest docker.io/z3nchada/etb-client-builder:latest

buildah bud --registries-conf=registries.conf -f "etb-client-runner.Dockerfile" -t "etb-client-runner" --format docker || record_image_failure "etb-client-runner"
podman tag localhost/etb-client-runner:latest docker.io/z3nchada/etb-client-runner:latest

cd ../

# next build the fuzzers

cd fuzzers
echo "Building fuzzers"
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
echo "Building etb-clients"
./buildah_dockers.sh
cd ../

# Check if log contains entries
if [ -s $FAILED_IMAGES_LOG ]; then
	printf "\n\n"
	RED='\033[0;31m'
	NO_COLOR='\033[0m'
	printf "${RED}The following images failed to build:${NO_COLOR}\n"
	cat $FAILED_IMAGES_LOG
	printf "\n\n"
else
	rm $FAILED_IMAGES_LOG

	cd ~/src/customer/customer-ethereum && \
		customer credentials.shell.registry -c "podman push us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:inst" && \
	echo "Done: etb-all-clients:inst image pushed successfully."
fi
