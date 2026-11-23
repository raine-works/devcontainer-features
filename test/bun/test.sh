#!/usr/bin/env bash
# Default options: the newest Bun release.
set -euo pipefail

source dev-container-features-test-lib

check "bun is installed" bun --version
check "bun is on /usr/local/bin" bash -c "[ \"\$(command -v bun)\" = /usr/local/bin/bun ]"

reportResults
