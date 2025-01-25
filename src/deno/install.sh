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

export DENO_INSTALL=/usr/local

if [ "${VERSION}" == "latest" ]; then
	curl -fsSL https://deno.land/install.sh | sh
else
	curl -fsSL https://deno.land/install.sh | deno_version="v${VERSION}" sh
fi