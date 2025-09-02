#!/usr/bin/env sh

set -e

APOLLO_DIR="$(cd $(dirname "$0")/.. && pwd)"
APOLLO_BUILD_DIR="$APOLLO_DIR/build"
APOLLO_ROOTFS_DIR="$APOLLO_DIR/rootfs"

if [ -z "$1" ]; then
    echo "Usage: $0 <project-name>"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DIR="$APOLLO_BUILD_DIR/$PROJECT_NAME"

shift
BUILD_ARGS="$@"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "Error: Build dir '$PROJECT_NAME' does not exist in '$PROJECT_DIR'."
    exit 1
fi

mkdir -p "$APOLLO_ROOTFS_DIR/src"

chmod +x "$PROJECT_DIR/build.sh"

podman run -it --rm \
    -v "$APOLLO_ROOTFS_DIR":/apollo \
    -v "$PROJECT_DIR/build.sh":/apollo/build.sh:ro \
    apollo-env-base /apollo/build.sh "$BUILD_ARGS"
