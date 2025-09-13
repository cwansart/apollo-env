#!/usr/bin/env sh

set -e

ROOT_DIR="$(cd $(dirname "$0")/.. && pwd)"
ROOTFS_DIR="$ROOT_DIR/rootfs/"

if [ "$1" = "--clean" ]; then
    echo "Cleaning rootfs"
    rm -rf "$ROOTFS_DIR"
    
fi

if ! command -v podman > /dev/null 2>&1; then
    echo "Error: podman is not installed."
    exit 1
fi


mkdir -p "$ROOTFS_DIR"

echo "Build base image"
$ROOT_DIR/container/build_image.sh

echo "Start bootstrapping for base"
echo "Build binutils"
$ROOT_DIR/build.sh base/binutils
echo "Build gcc pass 1"
$ROOT_DIR/build.sh base/gcc-pass1
$ROOT_DIR/build.sh base/kernel-header
#$ROOT_DIR/build.sh base/glibc
#$ROOT_DIR/build.sh base/gcc-pass2

echo "Building base system done"

