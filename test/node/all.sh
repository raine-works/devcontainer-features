#!/usr/bin/env bash
# Every package manager, each pinned to an exact version.
set -euo pipefail

source dev-container-features-test-lib

check "node version is pinned" bash -c "node --version | grep -x 'v22\.11\.0'"
check "pnpm version is pinned" bash -c "pnpm --version | grep -x '10\.4\.1'"
check "yarn is Yarn Berry 4.5.0" bash -c "yarn --version | grep -x '4\.5\.0'"
check "bun version is pinned" bash -c "bun --version | grep -x '1\.2\.0'"

reportResults
