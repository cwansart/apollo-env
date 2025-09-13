#!/usr/bin/env sh

set -e

umask 022
export LC_ALL=POSIX

DESTDIR="/apollo"
SOURCE_DIR="$DESTDIR/src"

PROJECT_NAME="linux"
PROJECT_VERSION="6.16.6"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://cdn.kernel.org/pub/linux/kernel/v6.x"
HASH="48b57b1e2e2166fb601a0e035d2fb6396e295d9245f0dfd6883d7c0c838b3002"

SOURCE_DIR_NAME="$PROJECT_NAME-$PROJECT_VERSION"
ARCHIVE_NAME="$SOURCE_DIR_NAME.$ARCHIVE_EXT"
PROJECT_URL="$PROJECT_URL/$ARCHIVE_NAME"

echo "Create source dir '$SOURCE_DIR'"
mkdir -p "$SOURCE_DIR"

echo "Change into $SOURCE_DIR"
cd "$SOURCE_DIR"

if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Downloading $PROJECT_URL"
    curl -fLO "$PROJECT_URL"
    echo "$HASH  $ARCHIVE_NAME" | sha256sum --check --status
fi

if [ ! -d "$SOURCE_DIR_NAME" ]; then
    echo "Unpack $ARCHIVE_NAME into $SOURCE_DIR"
    tar xf "$ARCHIVE_NAME"
fi

echo "Change into $SOURCE_DIR_NAME"
cd "$SOURCE_DIR_NAME"

echo "Clean kernel sources"
make mrproper

echo "Install kernel headers into $DESTDIR/usr"
make INSTALL_HDR_PATH="$DESTDIR/usr" headers_install
echo "Finished copying kernel headers"
