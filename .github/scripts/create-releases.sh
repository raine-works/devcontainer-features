#!/usr/bin/env bash
# Makes a GitHub Release for each feature's current version that's tagged (`feature_<id>_<version>`, the tag the
# devcontainers action pushes when it publishes) but has no release yet. Its notes are the commits that changed the
# feature since its previous version's tag. Safe to run again: a version with a release is left alone. With
# DRY_RUN=1 it prints each release instead of making it.
#
#   GH_TOKEN=… .github/scripts/create-releases.sh
set -euo pipefail

for manifest in src/*/devcontainer-feature.json; do
	id="$(jq -r .id "$manifest")"
	version="$(jq -r .version "$manifest")"
	name="$(jq -r .name "$manifest")"
	tag="feature_${id}_${version}"

	if ! git rev-parse -q --verify "refs/tags/$tag" > /dev/null; then
		echo "$id $version: not published (no tag $tag)"
		continue
	fi
	if gh release view "$tag" > /dev/null 2>&1; then
		echo "$id $version: already released"
		continue
	fi

	# The tag before this one, by version.
	previous="$(git tag --list "feature_${id}_*" | sort -V | grep -B1 -x "$tag" | grep -vx "$tag" || true)"
	range="${previous:+$previous..}$tag"
	changes="$(git log --no-merges --format='- %s' "$range" -- "src/$id" ':!*/README.md' |
		grep -v 'Automated documentation update' || true)"

	{
		echo "\`ghcr.io/${GITHUB_REPOSITORY:-raine-works/devcontainer-features}/$id:$version\`"
		echo
		if [ -n "$previous" ]; then
			echo "## Changes since ${previous#"feature_${id}_"}"
			echo
			echo "${changes:-- No changes to the feature itself.}"
		else
			echo "First release."
		fi
	} > "/tmp/notes-$id.md"

	if [ -n "${DRY_RUN:-}" ]; then
		echo "=== would release $tag: $name $version"
		cat "/tmp/notes-$id.md"
		continue
	fi
	gh release create "$tag" --verify-tag --latest=false --title "$name $version" --notes-file "/tmp/notes-$id.md"
	echo "$id $version: released"
done
