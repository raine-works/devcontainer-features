# Dev Container Features documentation

Small, dependable Dev Container Features that install Bun, Deno and Node.js (with npm, pnpm, yarn and bun) into a Debian or Ubuntu based dev container.

| Guide | What it covers |
| :--- | :--- |
| [Getting started](getting-started.md) | Adding the features from GHCR to `devcontainer.json`, version tags and requirements |
| [Checksums and verification](checksums.md) | What each feature verifies, and what it leaves to the upstream installer |
| [Troubleshooting](troubleshooting.md) | Failed builds, unsupported images and architectures, version errors |
| [Development](development.md) | Repository layout, running the tests, CI and releasing |

| Reference | What it covers |
| :--- | :--- |
| [Bun](reference/bun.md) | The `bun` feature: its option, install location and install method |
| [Deno](reference/deno.md) | The `deno` feature: its option, install location and install method |
| [Node.js](reference/node.md) | The `node` feature: every option, version resolution and package managers |
