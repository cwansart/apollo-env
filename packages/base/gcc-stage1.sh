#!/usr/bin/env sh

set -e

umask 022
export LANG=POSIX

PACKAGES_DIR="$(cd $(dirname "$0") && pwd)"
TARGET="$(uname -m)-apollo-linux-gnu"
PREFIX="/usr"
DESTDIR="/apollo"
SOURCE_DIR="$DESTDIR/src"

PROJECT_NAME="gcc"
PROJECT_VERSION="15.2.0"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://sourceware.org/pub/gcc/releases/$PROJECT_NAME-$PROJECT_VERSION"
HASH="438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"

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

echo "Prepare gcc dependencies"
sh "$PACKAGES_DIR/gmp.sh" "$(pwd)"
sh "$PACKAGES_DIR/mpfr.sh" "$(pwd)"
sh "$PACKAGES_DIR/mpc.sh" "$(pwd)"

mkdir -p build
cd build

../configure                  \
    --target="$TARGET"        \
    --prefix="$PREFIX"        \
    --with-sysroot="$DESTDIR" \
    --without-headers         \
    --disable-bootstrap       \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libstdcxx       \
    --enable-languages=c

make -j $(nproc) all-gcc
make DESTDIR="$DESTDIR" install-gcc

