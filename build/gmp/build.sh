#!/usr/bin/env sh

set -e

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="gmp-6.3.0"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://gmplib.org/download/gmp"
HASH="a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"

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

./configure --prefix="$INSTALL_DIR" --host=x86_64-linux-gnu
make -j $(nproc)
make check
make install
