#!/usr/bin/env bash
set -e

prerequisites=()

if ! command -v curl &> /dev/null; then
    prerequisites+=("curl")
fi

if ! command -v unzip &> /dev/null; then
    prerequisites+=("unzip")
fi

if [ ${#prerequisites[@]} -eq 0 ]; then
    echo "No packages to install"
else
    echo "Installing prerequisites: ${prerequisites[@]}"
    apt-get update
    apt-get install -y ${prerequisites[@]}
fi

if [ -z "${VERSION}" ]; then
	VERSION=latest
fi

export BUN_INSTALL=/usr/local

if [ "${VERSION}" == "latest" ]; then
	curl -fsSL https://bun.sh/install | bash
else
	curl -fsSL https://bun.sh/install | bash -s "bun-v${VERSION}"
fi