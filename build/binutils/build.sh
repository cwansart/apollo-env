#!/usr/bin/env sh

set -e

umask 022

export LC_ALL=POSIX
export PATH="/apollo/bin:$PATH"
export LD_LIBRARY_PATH="/apollo/lib:$LD_LIBRARY_PATH"

PROJECT_NAME="binutils-2.45"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://sourceware.org/pub/binutils/releases/"
HASH="c50c0e7f9cb188980e2cc97e4537626b1672441815587f1eab69d2a1bfbef5d2"

INSTALL_DIR="/apollo/bootstrap"
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

mkdir build
cd build
../configure --prefix="$INSTALL_DIR" \
             --with-sysroot="$INSTALL_DIR" \
             --target="$(uname -m)-apollo-linux-gnu" \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
make -j $(nproc)
make install
