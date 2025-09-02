#!/usr/bin/env sh

set -e

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="make-4.4.1"
ARCHIVE_EXT="tar.gz"
TARBALL_URL="https://ftp.fau.de/gnu/make"

INSTALL_DIR="/apollo"
SOURCE_DIR="/apollo/src/flex"

SOURCE_PATH="$SOURCE_DIR/$PROJECT_NAME"
ARCHIVE_NAME="$PROJECT_NAME.$ARCHIVE_EXT"
ARCHIVE_PATH="$SOURCE_DIR/$ARCHIVE_NAME"

if [ ! -e "$ARCHIVE_PATH" ]; then
    curl -L "$PROJECT_URL/$ARCHIVE_NAME" -o "$ARCHIVE_PATH"
fi

if [ ! -d "$SOURCE_PATH" ]; then
    tar xvf "$ARCHIVE_PATH" -C "$SOURCE_DIR"
fi


cd "$SOURCE_PATH"

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu
make -j $(nproc)
make install
