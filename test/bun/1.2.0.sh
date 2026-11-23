#!/usr/bin/env bash

set -euo pipefail

source dev-container-features-test-lib

check "validate bun version" bun --version | grep -E '(^|[^0-9.])1\.2\.0([^0-9.]|$)'

reportResults
