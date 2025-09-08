#!/usr/bin/env sh

set -e

PROJECT_NAME="gmp"
PROJECT_VERSION="6.3.0"
ARCHIVE_EXT="tar.xz"
PROJECT_URL="https://gmplib.org/download/gmp"
HASH="a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898"

SOURCE_DIR_NAME="$PROJECT_NAME-$PROJECT_VERSION"
ARCHIVE_NAME="$SOURCE_DIR_NAME.$ARCHIVE_EXT"

if [ -z "$1" ]; then
    echo "No target path given" >&2
    exit 1
fi
DEST_DIR="$1"

cd "$DEST_DIR"

if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Downloading $ARCHIVE_NAME"
    curl -fLO "$PROJECT_URL/$ARCHIVE_NAME"
    echo "$HASH  $ARCHIVE_NAME" | sha256sum --check --status
fi

if [ ! -d "$PROJECT_NAME" ]; then
    echo "Unpack $ARCHIVE_NAME into $DEST_DIR"
    tar xf "$ARCHIVE_NAME"
    mv "$PROJECT_NAME-$PROJECT_VERSION" "$PROJECT_NAME"
fi

