#!/usr/bin/env bash
# Default options: Node.js LTS plus pnpm.
set -euo pipefail

source dev-container-features-test-lib

check "node is installed" node --version
check "npm is installed" npm --version
check "pnpm is installed" pnpm --version

reportResults
