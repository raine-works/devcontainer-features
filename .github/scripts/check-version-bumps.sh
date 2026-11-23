#!/usr/bin/env bash
# Fails when a feature changed since <base> without a higher `version` in its devcontainer-feature.json: the release
# workflow publishes only versions GHCR doesn't have yet, so an unbumped change would never ship. README.md (generated)
# and NOTES.md (docs) don't count. A new feature needs no bump.
#
#   .github/scripts/check-version-bumps.sh origin/master
set -euo pipefail

base="$(git merge-base "${1:?usage: $0 <base-ref>}" HEAD)"
failed=0

features="$(git diff --name-only "$base" HEAD -- src/ |
	grep -vE '^src/[^/]+/(README|NOTES)\.md$' |
	cut -d/ -f2 | sort -u || true)"

for feature in $features; do
	manifest="src/$feature/devcontainer-feature.json"
	if [ ! -f "$manifest" ]; then
		echo "$feature: removed"
		continue
	fi
	new="$(jq -r .version "$manifest")"
	if ! old="$(git show "$base:$manifest" 2> /dev/null | jq -r .version)" || [ -z "$old" ]; then
		echo "$feature: new, at $new"
		continue
	fi
	if [ "$old" != "$new" ] && [ "$(printf '%s\n%s\n' "$old" "$new" | sort -V | tail -1)" = "$new" ]; then
		echo "$feature: $old → $new"
	else
		echo "::error file=$manifest::$feature changed but its version is still $old: bump it (patch for a fix, minor for a new option, major for a breaking change), or it won't be published."
		failed=1
	fi
done

[ -n "$features" ] || echo "No feature changed."
exit "$failed"
