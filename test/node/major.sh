#!/usr/bin/env bash
# A major nodeVersion resolves to the newest release of that major.
set -euo pipefail

source dev-container-features-test-lib

check "node major version is 20" bash -c "node --version | grep -E '^v20\.'"
check "pnpm version is pinned" bash -c "pnpm --version | grep -x '10\.4\.1'"

reportResults
