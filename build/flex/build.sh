#!/usr/bin/env sh

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

VERSION_TAG="v2.6.4"
REPO_URL="https://github.com/westes/flex.git"
SOURCE_DIR="/apollo/src/flex"
INSTALL_DIR="/apollo"

if [ ! -d "$SOURCE_DIR" ]; then
    git clone "$REPO_URL" "$SOURCE_DIR"
fi

cd "$SOURCE_DIR"

git fetch --all
git checkout "$VERSION_TAG"

./autogen.sh
./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu --disable-multilib
make -j $(nproc)
make install
