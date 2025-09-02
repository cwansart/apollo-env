#!/usr/bin/env sh

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

VERSION_TAG="1.3.1"
REPO_URL="https://gitlab.inria.fr/mpc/mpc.git"
SOURCE_DIR="/apollo/src/mpc"
INSTALL_DIR="/apollo"

if [ ! -d "$SOURCE_DIR" ]; then
    git clone "$REPO_URL" "$SOURCE_DIR"
fi

cd "$SOURCE_DIR"

git fetch --all
git checkout "$VERSION_TAG"

autoreconf -i
./configure --prefix="$INSTALL_DIR" \
            --with-gmp="$INSTALL_DIR" \
            --with-mpfr="$INSTALL_DIR" \
            --host=x86_64-linux-gnu
make -j $(nproc)
make install
