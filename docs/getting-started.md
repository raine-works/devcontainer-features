# Getting started

Each feature is published to the GitHub Container Registry under `ghcr.io/raine-works/devcontainer-features`. You reference one in the `features` section of your `devcontainer.json`, and the Dev Container CLI (or VS Code, or Codespaces) installs it when it builds the image.

## Add a feature

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/raine-works/devcontainer-features/bun:1": { "version": "1.2.0" },
        "ghcr.io/raine-works/devcontainer-features/deno:1": {},
        "ghcr.io/raine-works/devcontainer-features/node:1": { "pnpm": "10.4.1", "yarn": "latest", "bun": "latest" }
    }
}
```

Rebuild the container after you change the list. An empty options object (`{}`) takes every default.

| Feature | Reference | What it installs |
| :--- | :--- | :--- |
| [`bun`](reference/bun.md) | `ghcr.io/raine-works/devcontainer-features/bun:1` | The Bun runtime |
| [`deno`](reference/deno.md) | `ghcr.io/raine-works/devcontainer-features/deno:1` | The Deno runtime |
| [`node`](reference/node.md) | `ghcr.io/raine-works/devcontainer-features/node:1` | Node.js and npm, plus pnpm, yarn and bun on request |

## Version tags

The `:1` tag follows the feature’s major version, so you pick up compatible updates without breaking changes. You can also pin a full version such as `:1.0.0`.

## Pinning tool versions

Each feature has an option that selects the version of the tool it installs. Leave it out, or set it to its default, to get the newest release (Node.js defaults to the current LTS instead). See the reference page for each feature for the exact values it accepts.

## Requirements

- A Debian or Ubuntu based image. The install scripts use `apt-get` to fetch missing prerequisites.
- Network access during the image build, because the tools are downloaded from their upstream sites.
- For the `node` feature, an x86_64 or arm64 machine. See [Troubleshooting](troubleshooting.md) if a build fails.

The features are tested against `debian:latest`, `ubuntu:latest` and `mcr.microsoft.com/devcontainers/base:ubuntu`.

## Where the tools end up

The install scripts run as root during the image build and install into `/usr/local`, so the binaries are on `PATH` for every user, not just root.

## Using several features together

The `node` feature can install bun itself through its `bun` option. If you only need Bun, use the [`bun` feature](reference/bun.md).
