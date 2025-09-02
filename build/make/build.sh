#!/usr/bin/env sh

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

FOLDER_NAME="make-4.4.1"
TARBALL_NAME="$FOLDER_NAME.tar.gz"
TARBALL_URL="https://ftp.fau.de/gnu/make/$TARBALL_NAME"
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
make install
