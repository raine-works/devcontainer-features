#!/bin/bash
set -e

source dev-container-features-test-lib

check "node version is pinned" bash -c "node --version | grep -x 'v22\.11\.0'"
check "pnpm version is pinned" bash -c "pnpm --version | grep -x '10\.4\.1'"

reportResults
