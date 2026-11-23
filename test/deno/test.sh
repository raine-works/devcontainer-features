#!/usr/bin/env bash
# Default options: the newest Deno release.
set -euo pipefail

source dev-container-features-test-lib

check "deno is installed" deno --version
check "deno is on /usr/local/bin" bash -c "[ \"\$(command -v deno)\" = /usr/local/bin/deno ]"

reportResults
