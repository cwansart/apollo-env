#!/usr/bin/env

set -e

ROOT_DIR="$(cd $(dirname "$0")/.. && pwd)"
PACKAGE_FILE="$ROOT_DIR/user.pkgs"

if [ ! -f "PACKAGE_FILE" ]; then
    echo "Missing package definition: '$PACKAGE_FILE' not found"
    exit 1
fi

echo "Building user apps"

while IFS= read -r package || [ -n "$package" ]; do
    case "$package" in
        ""|\#*) continue ;;
    esac

    $ROOT_DIR/build.sh "$package"
done < "$PACKAGE_FILE"

echo "Finished building user packages"

