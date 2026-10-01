#!/usr/bin/env bash
# Installs Node.js system-wide into /usr/local from the official nodejs.org
# binary tarball (SHA-256 verified), then installs pnpm globally with npm.
#
# The dev container CLI runs this script as root during image build and exposes
# each feature option as an upper-case environment variable (option
# "nodeVersion" becomes $NODEVERSION).
set -e

NODE_VERSION="${NODEVERSION:-lts}"
PNPM_VERSION="${PNPMVERSION:-latest}"
DIST_URL="https://nodejs.org/dist"

# Debian/Ubuntu only: install curl, certificates and xz (the tarball is .tar.xz)
# when missing, so base images that already ship them are left untouched.
prerequisites=()

if ! command -v curl &> /dev/null; then
    prerequisites+=("curl")
fi

if ! command -v xz &> /dev/null; then
    prerequisites+=("xz-utils")
fi

if [ ! -e /etc/ssl/certs/ca-certificates.crt ]; then
    prerequisites+=("ca-certificates")
fi

if [ ${#prerequisites[@]} -eq 0 ]; then
    echo "No packages to install"
else
    echo "Installing prerequisites: ${prerequisites[*]}"
    apt-get update
    apt-get install -y "${prerequisites[@]}"
fi

# Map the machine architecture to the name used in Node.js release filenames.
case "$(uname -m)" in
    x86_64)  ARCH="x64" ;;
    aarch64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

# Resolve the option to an exact version (no leading "v").
case "${NODE_VERSION}" in
    lts)
        # index.json lists releases newest first, one per line; the first entry
        # whose "lts" field is a codename (not false) is the current LTS.
        VERSION="$(curl -fsSL "${DIST_URL}/index.json" | grep -m1 '"lts":"' | sed -E 's/.*"version":"v([^"]+)".*/\1/')"
        ;;
    latest)
        VERSION="$(curl -fsSL "${DIST_URL}/latest/SHASUMS256.txt" | grep -m1 "linux-${ARCH}.tar.xz" | sed -E 's/.*node-v([0-9.]+)-linux.*/\1/')"
        ;;
    [0-9]|[0-9][0-9])
        # Major version: the latest-vN.x directory always holds the newest N.x.y.
        VERSION="$(curl -fsSL "${DIST_URL}/latest-v${NODE_VERSION}.x/SHASUMS256.txt" | grep -m1 "linux-${ARCH}.tar.xz" | sed -E 's/.*node-v([0-9.]+)-linux.*/\1/')"
        ;;
    *)
        VERSION="${NODE_VERSION#v}"
        ;;
esac

if ! [[ "${VERSION}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Could not resolve Node.js version from '${NODE_VERSION}' (got '${VERSION}')" >&2
    exit 1
fi

echo "Installing Node.js ${VERSION} (${ARCH})"

# Download in a scratch directory that is removed on exit, even on failure.
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT
cd "${TMP_DIR}"

TARBALL="node-v${VERSION}-linux-${ARCH}.tar.xz"
curl -fsSLO "${DIST_URL}/v${VERSION}/${TARBALL}"
curl -fsSLO "${DIST_URL}/v${VERSION}/SHASUMS256.txt"

# Verify the tarball against the published checksum before extracting.
grep " ${TARBALL}\$" SHASUMS256.txt | sha256sum -c -

# Extract into /usr/local so node, npm and npx land on PATH for every user.
tar -xJf "${TARBALL}" -C /usr/local --strip-components=1 --no-same-owner \
    --exclude='CHANGELOG.md' --exclude='LICENSE' --exclude='README.md'

# Install pnpm globally; "latest" or a dist-tag also work as ${PNPM_VERSION}.
npm install -g "pnpm@${PNPM_VERSION}"
npm cache clean --force

echo "Installed: node $(node --version), npm $(npm --version), pnpm $(pnpm --version)"
