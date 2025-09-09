#!/usr/bin/env sh

set -e

PROJECT_NAME="mpc"
PROJECT_VERSION="1.3.1"
ARCHIVE_EXT="tar.gz"
PROJECT_URL="https://ftp.gnu.org/gnu/mpc"
HASH="ab642492f5cf882b74aa0cb730cd410a81edcdbec895183ce930e706c1c759b8"

SOURCE_DIR_NAME="$PROJECT_NAME-$PROJECT_VERSION"
ARCHIVE_NAME="$SOURCE_DIR_NAME.$ARCHIVE_EXT"
PROJECT_URL="$PROJECT_URL/$ARCHIVE_NAME"

if [ -z "$1" ]; then
    echo "No target path given" >&2
    exit 1
fi
DEST_DIR="$1"

cd "$DEST_DIR"

echo "Retrieving $SOURCE_DIR_NAME and place it in $DEST_DIR/$PROJECT_NAME"
if [ ! -f "$ARCHIVE_NAME" ]; then
    echo "Downloading $PROJECT_URL"
    curl -fLO "$PROJECT_URL"
    echo "$HASH  $ARCHIVE_NAME" | sha256sum --check --status
fi

if [ ! -d "$PROJECT_NAME" ]; then
    echo "Unpack $ARCHIVE_NAME into $DEST_DIR"
    tar xf "$ARCHIVE_NAME" 
    mv "$PROJECT_NAME-$PROJECT_VERSION" "$PROJECT_NAME"
fi

echo "Done with $SOURCE_DIR_NAME"

