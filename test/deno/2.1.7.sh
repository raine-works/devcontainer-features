#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate deno version" deno --version | grep '2.1.7'

reportResults