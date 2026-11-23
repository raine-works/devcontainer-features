#!/usr/bin/env bash

set -euo pipefail

source dev-container-features-test-lib

check "validate deno version" deno --version | grep -E '(^|[^0-9.])2\.0\.0([^0-9.]|$)'

reportResults
