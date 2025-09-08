#!/usr/bin/env sh

set -e

PROJECT_NAME="mpfr"
PROJECT_VERSION="4.2.2"
ARCHIVE_EXT="tar.gz"
PROJECT_URL="https://www.mpfr.org/mpfr-current"
HASH="826cbb24610bd193f36fde172233fb8c009f3f5c2ad99f644d0dea2e16a20e42"

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

