## Notes

- Installs Node.js from the official nodejs.org binary tarball into `/usr/local`, verified against the published SHA-256 checksum, then installs the requested package managers globally with `npm`.
- Requires a Debian/Ubuntu based image on x86_64 or arm64 (`apt-get` fetches `curl`, `xz-utils` and `ca-certificates` when missing).
- `nodeVersion` accepts `lts` (default), `latest`, a major such as `22`, or an exact version such as `22.11.0`.
- `packageManagers` is a comma-separated list. Supported: `npm`, `pnpm`, `yarn`, `bun`. Append `@version` to pin one (`pnpm@10.4.1`, `bun@1.2.0`). Default is `pnpm`; use `none` to install Node.js only. npm itself is always bundled with Node.js, list it only to upgrade or pin it.
- **Yarn:** plain `yarn` (or `yarn@1`) installs Yarn Classic 1.x. `yarn@4` (any version 2 or newer) or `yarn@berry` installs modern Yarn from `@yarnpkg/cli-dist`. Only one Yarn can be installed.
- For global installs with `pnpm add -g`, run `pnpm setup` first so pnpm has a global bin directory.
- The official [`ghcr.io/devcontainers/features/node`](https://github.com/devcontainers/features/tree/main/src/node) feature also installs pnpm and yarn. Use this feature for a smaller, checksum-verified install without nvm, with bun available as well.

## Support

If this feature saves you time, you can support its upkeep:

<a href="https://buymeacoffee.com/raineworks"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee" /></a>
