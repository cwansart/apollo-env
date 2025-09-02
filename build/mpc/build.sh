#!/usr/bin/env sh

set -e

export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="mpc-1.3.1"
ARCHIVE_EXT="tar.gz"
PROJECT_URL="https://ftp.gnu.org/gnu/mpc"
HASH="ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"

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

./configure --prefix="$INSTALL_DIR" \
            --with-gmp="$INSTALL_DIR" \
            --with-mpfr="$INSTALL_DIR" \
            --host=x86_64-linux-gnu
make -j $(nproc)
make install
