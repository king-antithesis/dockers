#!/usr/bin/env bash
# build the base-images (note not needed since they pull from z3nchada/<>) uncomment to update them.

# this script assumes that ./buildah_dockers.sh has already been run

export FAILED_IMAGES_LOG=`pwd`/failed_images.log
echo -n > $FAILED_IMAGES_LOG
# Import `record_image_failure` function
source ./common.sh

cd consensus-clients

echo "Building consensus-clients"

./buildah_dockers_uninst.sh 

cd ../

# now that we have all the prereqs build the etb-client images.

cd etb-clients

buildah bud --registries-conf=registries.conf -f "etb-all-clients.Dockerfile" -t "etb-all-clients:latest" --format docker || record_image_failure "etb-all-clients:latest"
podman tag localhost/etb-all-clients:latest us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:latest

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
		customer credentials.shell.registry -c "podman push us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:latest" && \
	echo "Done: etb-all-clients:latest image pushed successfully."
fi
