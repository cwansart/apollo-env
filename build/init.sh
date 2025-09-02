#!/usr/bin/env sh

if ! command -v podman > /dev/null 2>&1; then
    echo "Error: podman is not installed."
    exit 1
fi


chmod +x base/build.sh
./base/build.sh

# build gcc based on the base system
./build.sh gcc

# gcc requires gmp, mpfr and mpc so we compile it with our new compiler
./build.sh gmp
./build.sh mpfr
./build.sh mpc

# rebuild gcc with our gmp, mpfr and mpc
./build.sh gcc --clean

######################################
# TODO: build glibc here
#####################################

./build.sh make
