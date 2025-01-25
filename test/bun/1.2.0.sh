#!/bin/bash

set -e

source dev-container-features-test-lib

check "validate bun version" bun --version | grep '1.2.0'

reportResults