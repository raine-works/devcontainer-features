# Bun

Installs the [Bun](https://bun.sh) JavaScript runtime system-wide.

```json
"ghcr.io/raine-works/devcontainer-features/bun:1": { "version": "1.2.0" }
```

## Options

| Option | Type | Default | What it does |
| :--- | :--- | :--- | :--- |
| `version` | string | `latest` | The Bun version to install. `latest` installs the newest release. Anything else is treated as an exact release such as `1.2.0`. An empty value falls back to `latest`. |

Give `version` a bare version number. The script adds the `bun-v` release-tag prefix itself, so `1.2.0` becomes the `bun-v1.2.0` release.

## What the feature does

1. Installs `curl` and `unzip` with `apt-get` if either is missing. Nothing is installed when both are already there.
2. Sets `BUN_INSTALL=/usr/local` so the binary lands in `/usr/local/bin`, on `PATH` for all users.
3. Runs Bun’s own installer from `https://bun.sh/install`, with the release tag as its argument when `version` is not `latest`.

## Verification

This feature does not verify a checksum itself. It trusts the upstream installer, downloaded over HTTPS. See [Checksums and verification](../checksums.md).

## Requirements

A Debian or Ubuntu based image. The script does not check the CPU architecture; it leaves that to the upstream installer.
