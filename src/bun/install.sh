#!/usr/bin/env bash
# Installs Bun system-wide into /usr/local using the upstream installer.
#
# The dev container CLI runs this script as root during image build and exposes
# each feature option as an upper-case environment variable (option "version"
# becomes $VERSION).
set -e

# Fall back to the newest release when the option is unset or empty.
if [ -z "${VERSION}" ]; then
    VERSION=latest
fi

# The option is user input that ends up in the installer's download URL, so
# accept only "latest" or a bare X.Y.Z release, and fail before installing or
# downloading anything.
if [ "${VERSION}" != "latest" ] && ! [[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version '${VERSION}': use 'latest' or an exact release such as '1.2.0'" >&2
    exit 1
fi

# Debian/Ubuntu only: the upstream installer needs curl (to download) and
# unzip (to extract the release archive). Install them only if missing so the
# build stays fast and base images that already ship them are left untouched.
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
    echo "Installing prerequisites: ${prerequisites[*]}"
    apt-get update
    apt-get install -y "${prerequisites[@]}"
fi

# Install to /usr/local so the binary lands on PATH for every user, not just root.
export BUN_INSTALL=/usr/local

# "latest" uses the installer's default; anything else pins an exact release
# (e.g. "1.2.0"; the release-tag prefix is added here).
if [ "${VERSION}" == "latest" ]; then
    curl -fsSL https://bun.sh/install | bash
else
    curl -fsSL https://bun.sh/install | bash -s "bun-v${VERSION}"
fi
