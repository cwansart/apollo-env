#!/usr/bin/env sh

set -e

umask 022
export LC_ALL=POSIX

PACKAGES_DIR="$(cd $(dirname "$0") && pwd)"
TARGET="$(uname -m)-apollo-linux-gnu"
PREFIX="/usr"
DESTDIR="/apollo"
SOURCE_DIR="$DESTDIR/src"

PROJECT_NAME="binutils"
PROJECT_VERSION="2.45"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://sourceware.org/pub/binutils/releases/"
HASH="c50c0e7f9cb188980e2cc97e4537626b1672441815587f1eab69d2a1bfbef5d2"

SOURCE_DIR_NAME="$PROJECT_NAME-$PROJECT_VERSION"
ARCHIVE_NAME="$PROJECT_NAME.$ARCHIVE_EXT"

mkdir -p "$SOURCE_DIR"
cd "$SOURCE_DIR"

if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Downloading $ARCHIVE_NAME"
    curl -fLO "$PROJECT_URL/$ARCHIVE_NAME"
    echo "$HASH  $ARCHIVE_NAME" | sha256sum --check --status
fi

if [ ! -d "$SOURCE_DIR_NAME" ]; then
    echo "Unpack $ARCHIVE_NAME into $SOURCE_DIR"
    tar xf "$ARCHIVE_NAME"
fi

cd "$SOURCE_DIR_NAME"

mkdir build
cd build

../configure --prefix="$PREFIX" \
             --with-sysroot="$DESTDIR" \
             --target="$TARGET" \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
make -j $(nproc)
make DESTDIR="$DESTDIR" install
