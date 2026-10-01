
# Node.js with package managers (node)

Install Node.js (checksum verified) with npm plus your choice of pnpm, yarn and bun.

## Example Usage

```json
"features": {
    "ghcr.io/raine-works/devcontainer-features/node:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| nodeVersion | Node.js version: 'lts', 'latest', a major version such as '22', or an exact version such as '22.11.0'. | string | lts |
| pnpm | pnpm version: 'none' to skip, 'latest', or a version such as '10.4.1'. | string | latest |
| yarn | Yarn version: 'none' to skip, 'latest' (or 'berry') for modern Yarn, 'classic' for Yarn 1.x, or a version such as '4.5.0' or '1.22.22'. | string | none |
| bun | Bun version: 'none' to skip, 'latest', or a version such as '1.2.0'. | string | none |

## Notes

- Installs Node.js from the official nodejs.org binary tarball into `/usr/local`, verified against the published SHA-256 checksum, then installs the requested package managers globally with `npm`.
- Requires a Debian/Ubuntu based image on x86_64 or arm64 (`apt-get` fetches `curl`, `xz-utils` and `ca-certificates` when missing).
- `nodeVersion` accepts `lts` (default), `latest`, a major such as `22`, or an exact version such as `22.11.0`.
- npm is always installed (it ships with Node.js). Use the `pnpm`, `yarn` and `bun` options for the rest. Each accepts `none` (skip), `latest`, or a version such as `10.4.1`. `pnpm` defaults to `latest`; `yarn` and `bun` default to `none`.
- **Yarn:** `yarn` accepts `latest` (or `berry`) for modern Yarn, `classic` for Yarn 1.x, or a version. Versions 1.x use Yarn Classic; 2 and newer use `@yarnpkg/cli-dist`.
- npm itself is not upgraded; it is the version bundled with the selected Node.js.
- For global installs with `pnpm add -g`, run `pnpm setup` first so pnpm has a global bin directory.
- The official [`ghcr.io/devcontainers/features/node`](https://github.com/devcontainers/features/tree/main/src/node) feature also installs pnpm and yarn. Use this feature for a smaller, checksum-verified install without nvm, with bun available as well.

## Support

If this feature saves you time, you can support its upkeep:

<a href="https://buymeacoffee.com/raineworks"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee" /></a>


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/raine-works/devcontainer-features/blob/main/src/node/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
