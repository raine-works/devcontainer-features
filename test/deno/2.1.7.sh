#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate deno version" deno --version | grep -E '(^|[^0-9.])2.1.7([^0-9.]|$)'

reportResults