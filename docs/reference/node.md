# Node.js

Installs [Node.js](https://nodejs.org) from the official binary tarball, verifies its SHA-256 checksum, and optionally installs pnpm, yarn and bun globally with npm. npm ships with Node.js and is always installed.

```json
"ghcr.io/raine-works/devcontainer-features/node:1": {
    "nodeVersion": "22",
    "pnpm": "10.4.1",
    "yarn": "classic",
    "bun": "latest"
}
```

## Options

| Option | Type | Default | What it does |
| :--- | :--- | :--- | :--- |
| `nodeVersion` | string | `lts` | The Node.js version. See below. |
| `pnpm` | string | `latest` | pnpm: `none` to skip, `latest`, or a version such as `10.4.1`. |
| `yarn` | string | `none` | Yarn: `none` to skip, `latest` (or `berry`) for modern Yarn, `classic` for Yarn 1.x, or a version such as `4.5.0` or `1.22.22`. |
| `bun` | string | `none` | Bun: `none` to skip, `latest`, or a version such as `1.2.0`. |

The editor suggests `lts`, `latest`, `24`, `22` and `20` for `nodeVersion`, `none` and `latest` for `pnpm` and `bun`, and `none`, `latest` and `classic` for `yarn`. These are suggestions; the values described here are all accepted.

### nodeVersion

| Value | Result |
| :--- | :--- |
| `lts` | The newest release that has an LTS codename, read from `https://nodejs.org/dist/index.json`. |
| `latest` | The newest release, read from `https://nodejs.org/dist/latest/SHASUMS256.txt`. |
| A major such as `22` (one or two digits) | The newest `22.x.y`, read from the `latest-v22.x` directory. |
| An exact version such as `22.11.0` | That release. A leading `v` is accepted and removed. |

After resolving, the version must look like `X.Y.Z`. Otherwise the build stops with `Could not resolve Node.js version`. A partial version such as `22.11` is not a major and fails this check.

### Package managers

The `pnpm`, `yarn` and `bun` values may contain only letters, digits, `.`, `_` and `-`. Anything else stops the build with `Invalid package manager version`, because the values end up on an `npm install` command line.

| Option and value | npm package installed |
| :--- | :--- |
| `pnpm`: `latest` or a version | `pnpm@<value>` |
| `bun`: `latest` or a version | `bun@<value>` |
| `yarn`: `classic` | `yarn@1` |
| `yarn`: `1` or `1.x.y` | `yarn@<value>` (Yarn Classic) |
| `yarn`: `latest` or `berry` | `@yarnpkg/cli-dist@latest` (modern Yarn) |
| `yarn`: any other version, such as `4.5.0` | `@yarnpkg/cli-dist@<value>` (modern Yarn) |

All requested packages are installed in a single `npm install -g`. npm itself is not upgraded; it is the version bundled with the selected Node.js.

## What the feature does

1. Installs `curl`, `xz-utils` and `ca-certificates` with `apt-get` if missing.
2. Maps the machine architecture (`x86_64` to `x64`, `aarch64` to `arm64`). Any other architecture stops the build.
3. Resolves `nodeVersion` to an exact version.
4. Downloads `node-v<version>-linux-<arch>.tar.xz` and `SHASUMS256.txt` from `https://nodejs.org/dist/v<version>/`, and checks the tarball against the checksum. See [Checksums and verification](../checksums.md).
5. Extracts into `/usr/local`, so `node`, `npm` and `npx` are on `PATH` for all users. The tarball’s `CHANGELOG.md`, `LICENSE` and `README.md` are skipped.
6. Installs the requested package managers globally, cleans the npm cache and prints the installed versions.

## Notes

- For global installs with `pnpm add -g`, run `pnpm setup` first so pnpm has a global bin directory.
- The official [`ghcr.io/devcontainers/features/node`](https://github.com/devcontainers/features/tree/main/src/node) feature also installs pnpm and yarn. This feature gives a smaller, checksum-verified install without nvm, with bun available as well.
