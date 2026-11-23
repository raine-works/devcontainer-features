# Troubleshooting

Feature install scripts run during the image build, so errors appear in the container build log. The build stops on the first error.

## `apt-get: command not found`

The features need a Debian or Ubuntu based image, because they use `apt-get` to fetch missing prerequisites (`curl` and `unzip` for Bun and Deno; `curl`, `xz-utils`, `ca-certificates` and `libatomic1` for Node.js). Use a Debian or Ubuntu base image.

## `Unsupported architecture`

The `node` feature supports x86_64 and aarch64 (arm64) only. Bun and Deno do not check the architecture themselves; support is up to their installers.

## `libatomic.so.1: cannot open shared object file`

The `node` binary needs `libatomic1`, which bare `debian:latest` and `ubuntu:latest` images don’t include. Since `node` 1.0.1 the feature installs it when it’s missing; on 1.0.0, use `ghcr.io/raine-works/devcontainer-features/node:1` to get the fix, or install `libatomic1` in the image first.

## `Could not resolve Node.js version from '…'`

The `nodeVersion` value could not be turned into an exact `X.Y.Z` version. Check that it is `lts`, `latest`, a one or two digit major such as `22`, or a full version such as `22.11.0`. Values like `22.11` are not accepted. A nonexistent major (such as `99`) resolves to nothing and fails the same way.

## `Invalid package manager version '…'`

A `pnpm`, `yarn` or `bun` value contains characters other than letters, digits, `.`, `_` and `-`. Use `none`, `latest`, or a plain version.

## A checksum failure

`sha256sum -c` prints `FAILED` when the downloaded Node.js tarball does not match the published checksum. Retry the build. If it persists, the download is being altered or truncated, for example by a proxy.

## `Invalid version '…'`

The Bun or Deno `version` value is neither `latest` nor a bare `X.Y.Z` release. Since `bun` and `deno` 1.0.1 the features reject it before installing anything. Drop any prefix (`v`, `bun-v`) and give all three parts, such as `1.2.0`.

## Pinned version not found

For Bun, Deno and an exact Node.js version, a version that does not exist makes the download fail (`curl -f` exits with an error). Give a bare version such as `1.2.0`, without a prefix, for Bun and Deno.

## `pnpm add -g` fails

Run `pnpm setup` first so pnpm has a global bin directory.

## An upstream installer changed

The Bun and Deno installers are fetched at build time. If their install script changes, a build can break without any change here. The scheduled weekly CI run exists to catch this, so check its results in the repository’s Actions tab.
