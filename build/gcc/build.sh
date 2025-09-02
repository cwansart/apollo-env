#!/usr/bin/env sh

set -e

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="gcc-15.2.0"
ARCHIVE_EXT="tar.gz"
PROJECT_URL="https://ftp.gwdg.de/pub/misc/gcc/releases/gcc-15.2.0"
HASH="7294d65cc1a0558cb815af0ca8c7763d86f7a31199794ede3f630c0d1b0a5723"

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

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu --disable-multilib
make -j $(nproc)
make install
