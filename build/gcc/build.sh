#!/usr/bin/env sh

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

VERSION_TAG="releases/gcc-15.2.0"
REPO_URL="https://gcc.gnu.org/git/gcc.git"
SOURCE_DIR="/apollo/src/gcc"
INSTALL_DIR="/apollo"

if [ ! -d "$SOURCE_DIR" ]; then
    git clone "$REPO_URL" "$SOURCE_DIR"
fi

cd "$SOURCE_DIR"

git fetch --all
git checkout "$VERSION_TAG"

if echo "$@" | grep -q -- --clean; then
    if [ -f Makefile ]; then
        make distclean
    fi
fi

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu --disable-multilib
make -j $(nproc)
make install
