#!/usr/bin/env sh

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

FOLDER_NAME="gmp-6.3.0"
TARBALL_NAME="$FOLDER_NAME.tar.xz"
TARBALL_URL="https://gmplib.org/download/gmp/$TARBALL_NAME"
SOURCE_DIR="/apollo/src"
INSTALL_DIR="/apollo"

if [ ! -e "$SOURCE_DIR/$TARBALL_NAME" ]; then
    curl "$TARBALL_URL" -o "$SOURCE_DIR/$TARBALL_NAME"
fi

if [ ! -d "$SOURCE_DIR/$FOLDER_NAME" ]; then
    tar xvf "$SOURCE_DIR/$TARBALL_NAME" -C "$SOURCE_DIR"
fi

cd "$SOURCE_DIR/$FOLDER_NAME"

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu
make -j $(nproc)
make check
make install
