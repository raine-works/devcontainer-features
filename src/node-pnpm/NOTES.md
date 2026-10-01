## Notes

- Installs Node.js from the official nodejs.org binary tarball into `/usr/local`, verified against the published SHA-256 checksum, then installs pnpm globally with `npm`.
- Requires a Debian/Ubuntu based image on x86_64 or arm64 (`apt-get` fetches `curl`, `xz-utils` and `ca-certificates` when missing).
- `nodeVersion` accepts `lts` (default), `latest`, a major such as `22`, or an exact version such as `22.11.0`.
- `pnpmVersion` accepts `latest` (default), a dist-tag, or an exact version.
- For global installs with `pnpm add -g`, run `pnpm setup` first so pnpm has a global bin directory.
- The official [`ghcr.io/devcontainers/features/node`](https://github.com/devcontainers/features/tree/main/src/node) feature also installs pnpm via its `pnpmVersion` option. Use this feature if you want a smaller, checksum-verified install without nvm.

## Support

If this feature saves you time, you can support its upkeep:

<a href="https://buymeacoffee.com/raineworks"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee" /></a>
