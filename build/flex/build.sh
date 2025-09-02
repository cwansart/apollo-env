#!/usr/bin/env sh

set -e

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="flex-2.6.4"
ARCHIVE_EXT="tar.gz"
TARBALL_URL="https://github.com/westes/flex/releases/download/v2.6.4"

SOURCE_DIR="/apollo/src/flex"
INSTALL_DIR="/apollo"

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

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu --disable-multilib
make -j $(nproc)
make install
