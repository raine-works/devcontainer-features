#!/bin/bash
set -e

source dev-container-features-test-lib

check "pnpm is installed" pnpm --version
check "yarn is Yarn Berry 4" bash -c "yarn --version | grep -E '^4\.'"
check "bun is installed" bun --version

reportResults
