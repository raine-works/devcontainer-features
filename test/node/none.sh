#!/bin/bash
set -e

source dev-container-features-test-lib

check "node is installed" node --version
check "npm is installed" npm --version
check "pnpm is not installed" bash -c "! command -v pnpm"

reportResults
