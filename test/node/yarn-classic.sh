#!/usr/bin/env bash
# yarn "classic" resolves to the newest Yarn 1.x.
set -euo pipefail

source dev-container-features-test-lib

check "node version is pinned" bash -c "node --version | grep -x 'v22\.11\.0'"
check "yarn is Yarn Classic 1.x" bash -c "yarn --version | grep -E '^1\.'"
check "pnpm is not installed" bash -c "! command -v pnpm"

reportResults
