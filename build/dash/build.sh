#!/usr/bin/env sh

set -e

umask 022

export LANG=POSIX
export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="dash-0.5.12"
ARCHIVE_EXT="tar.gz"
PROJECT_URL="http://gondor.apana.org.au/~herbert/dash/files/"
HASH="6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a"

INSTALL_DIR="/apollo"
SOURCE_DIR="/apollo/src"

SOURCE_PATH="$SOURCE_DIR/$PROJECT_NAME"
ARCHIVE_NAME="$PROJECT_NAME.$ARCHIVE_EXT"
ARCHIVE_PATH="$SOURCE_DIR/$ARCHIVE_NAME"
HASH_FILE="$ARCHIVE_PATH.sha256"


if [ ! -e "$ARCHIVE_PATH" ]; then
    curl -L "$PROJECT_URL/$ARCHIVE_NAME" -o "$ARCHIVE_PATH"
    printf "%s *%s\n" "$HASH" "$ARCHIVE_PATH" > "$HASH_FILE" 
    if ! sha256sum --check --status "$HASH_FILE"; then
        exit 1
    fi
    rm -f "$HASH_FILE"
fi

if [ ! -d "$SOURCE_PATH" ]; then
    tar xvf "$ARCHIVE_PATH" -C "$SOURCE_DIR"
fi


cd "$SOURCE_PATH"

if [ "$1" = "--clean" ]; then
    make distclean
fi

./configure --prefix="$INSTALL_DIR" 
make -j $(nproc)
make install
