#!/bin/bash
set -e

source dev-container-features-test-lib

check "node major version is 20" bash -c "node --version | grep -E '^v20\.'"
check "pnpm is installed" pnpm --version

reportResults
