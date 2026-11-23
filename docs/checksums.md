# Checksums and verification

The three features differ in what they verify.

| Feature | Verification |
| :--- | :--- |
| `node` | SHA-256 of the Node.js tarball, checked by the feature itself |
| `bun` | None by the feature; the upstream installer is fetched over HTTPS |
| `deno` | None by the feature; the upstream installer is fetched over HTTPS |

## Node.js

The `node` feature downloads the tarball and the release’s `SHASUMS256.txt` from the same directory on nodejs.org. It then runs:

```bash
grep " ${TARBALL}$" SHASUMS256.txt | sha256sum -c -
```

The script runs with `set -e`, so a mismatch fails the build before anything is extracted. A missing entry for the tarball in the checksum file also fails, because `sha256sum -c` receives no input and reports an error.

The checksum file comes from the same site as the tarball, so this guards against corrupt or truncated downloads and against a tarball that does not match its published checksum. It does not check a signature on `SHASUMS256.txt`.

The package managers (pnpm, yarn and bun through the `node` feature) are installed with `npm install -g`, so they get npm’s own integrity checks. The feature adds none.

## Bun and Deno

The `bun` and `deno` features download each project’s installer script (`https://bun.sh/install`, `https://deno.land/install.sh`) over HTTPS and run it. The feature does not check a checksum of the script or of the release the installer downloads. Whatever verification the upstream installers do is theirs.

If you need a verified install of Bun, the `node` feature’s `bun` option installs it through npm instead.
