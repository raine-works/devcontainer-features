#!/usr/bin/env bash
# Installs Node.js system-wide into /usr/local from the official nodejs.org
# binary tarball (SHA-256 verified), then installs the requested package
# managers (npm, pnpm, yarn, bun) globally with npm.
#
# The dev container CLI runs this script as root during image build and exposes
# each feature option as an upper-case environment variable (option
# "nodeVersion" becomes $NODEVERSION, "packageManagers" becomes
# $PACKAGEMANAGERS).
set -e

NODE_VERSION="${NODEVERSION:-lts}"
PACKAGE_MANAGERS="${PACKAGEMANAGERS-pnpm}"
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

# Turn "pnpm,yarn@4,bun@1.2.0" into npm package specs. The option is user input
# that ends up on an npm command line, so names are allow-listed and versions
# are restricted to a safe character set.
packages=()
npm_spec=""
seen=" "
IFS=',' read -ra requested <<< "${PACKAGE_MANAGERS}"
for entry in "${requested[@]}"; do
    entry="${entry//[[:space:]]/}"
    if [ -z "${entry}" ] || [ "${entry}" == "none" ]; then
        continue
    fi

    name="${entry%%@*}"
    version="latest"
    if [[ "${entry}" == *@* ]]; then
        version="${entry#*@}"
    fi

    if ! [[ "${version}" =~ ^[A-Za-z0-9._-]+$ ]]; then
        echo "Invalid version in packageManagers entry '${entry}'" >&2
        exit 1
    fi
    if [[ "${seen}" == *" ${name} "* ]]; then
        echo "Duplicate package manager '${name}' in packageManagers" >&2
        exit 1
    fi
    seen+="${name} "

    case "${name}" in
        npm)
            npm_spec="npm@${version}"
            ;;
        pnpm | bun)
            packages+=("${name}@${version}")
            ;;
        yarn)
            # Plain "yarn" and 1.x are Yarn Classic (npm package "yarn").
            # Anything newer is Yarn Berry, shipped as @yarnpkg/cli-dist;
            # "berry" is shorthand for its latest release.
            if [ "${version}" == "latest" ] || [[ "${version}" =~ ^1(\.|$) ]]; then
                packages+=("yarn@${version}")
            elif [ "${version}" == "berry" ]; then
                packages+=("@yarnpkg/cli-dist@latest")
            else
                packages+=("@yarnpkg/cli-dist@${version}")
            fi
            ;;
        *)
            echo "Unsupported package manager '${name}'. Supported: npm, pnpm, yarn, bun" >&2
            exit 1
            ;;
    esac
done

# Upgrade npm on its own first so the remaining installs use the new version.
if [ -n "${npm_spec}" ]; then
    npm install -g "${npm_spec}"
fi

if [ ${#packages[@]} -gt 0 ]; then
    npm install -g "${packages[@]}"
fi
npm cache clean --force

echo "Installed: node $(node --version), npm $(npm --version)"
for manager in pnpm yarn bun; do
    if command -v "${manager}" &> /dev/null; then
        echo "  ${manager} $(${manager} --version)"
    fi
done
