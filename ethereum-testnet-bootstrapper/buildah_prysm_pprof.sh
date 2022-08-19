cd consensus-clients

buildah bud --registries-conf=registries.conf -f "prysm_pprof.Dockerfile" -t "prysm:pprof" --format docker

cd ..

cd etb-clients/

buildah bud --registries-conf=registries.conf -f "etb-all-clients_prysm-pprof.Dockerfile" -t "etb-all-clients:prysm-pprof" --format docker
podman tag localhost/etb-all-clients:prysm-pprof us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:prysm-pprof

cd ~/src/customer/customer-ethereum && customer credentials.shell.registry -c "podman push us-central1-docker.pkg.dev/molten-verve-216720/ethereum-repository/etb-all-clients:prysm-pprof"
