#!/bin/bash
set -e

source dev-container-features-test-lib

check "yarn is Yarn Classic 1.x" bash -c "yarn --version | grep -E '^1\.'"
check "pnpm is not installed" bash -c "! command -v pnpm"

reportResults
