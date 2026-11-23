#!/usr/bin/env bash
# pnpm "none" skips pnpm; npm still ships with Node.js.
set -euo pipefail

source dev-container-features-test-lib

check "node version is pinned" bash -c "node --version | grep -x 'v22\.11\.0'"
check "npm is installed" npm --version
check "pnpm is not installed" bash -c "! command -v pnpm"

reportResults
