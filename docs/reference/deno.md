# Deno

Installs the [Deno](https://deno.com) JavaScript runtime system-wide.

```json
"ghcr.io/raine-works/devcontainer-features/deno:1": { "version": "2.1.7" }
```

## Options

| Option | Type | Default | What it does |
| :--- | :--- | :--- | :--- |
| `version` | string | `latest` | The Deno version to install. `latest` installs the newest release. Otherwise it must be an exact release such as `2.1.7`. An empty value falls back to `latest`. |

Give `version` a bare `X.Y.Z` version number. The script adds the `v` release-tag prefix itself, so `2.1.7` becomes `v2.1.7`. Any other value (`2.1`, `v2.1.7`) fails the build with `Invalid version '…'` before anything is installed.

## What the feature does

1. Checks that `version` is `latest` or a bare `X.Y.Z` release, and stops the build otherwise.
2. Installs `curl` and `unzip` with `apt-get` if either is missing. Nothing is installed when both are already there.
3. Sets `DENO_INSTALL=/usr/local` so the binary lands in `/usr/local/bin`, on `PATH` for all users.
4. Runs Deno’s own installer from `https://deno.land/install.sh`, passing the tag in its `deno_version` variable when `version` is not `latest`.

## Verification

This feature does not verify a checksum itself. It trusts the upstream installer, downloaded over HTTPS. See [Checksums and verification](../checksums.md).

## Requirements

A Debian or Ubuntu based image. The script does not check the CPU architecture; it leaves that to the upstream installer.
