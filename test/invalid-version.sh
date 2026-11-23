#!/usr/bin/env bash
# Checks that a feature's install script rejects an invalid `version` option.
#
# Usage: test/invalid-version.sh <path to the feature's install.sh>
#
# The dev container test runner can only assert that a build succeeds, so this
# failure path is tested outside it: CI runs the install script directly, as an
# unprivileged user, with each bad value. The script must fail with its
# "Invalid version" error before installing or downloading anything. Exits 0
# when every value is rejected that way, 1 otherwise.
set -euo pipefail

install_script="$1"
status=0

# A minor-only version, a tag prefix, shell and path characters, and stray
# whitespace: none is "latest" or a bare X.Y.Z release.
for version in "1.2" "v1.2.0" "bun-v1.2.0" "1.2.0; echo injected" "../1.2.0" "1.2.0 " "latest "; do
    if output="$(VERSION="${version}" bash "${install_script}" 2>&1)"; then
        echo "FAIL: '${version}' was accepted" >&2
        status=1
    elif ! grep -qF "Invalid version '${version}'" <<< "${output}"; then
        echo "FAIL: '${version}' failed without the 'Invalid version' error:" >&2
        echo "${output}" >&2
        status=1
    else
        echo "PASS: '${version}' rejected"
    fi
done

exit "${status}"
