# Agent guidance for devcontainer-features

## Raineworks base rules

This repository follows Raineworks' base rules, in [`.raineworks/base.md`](.raineworks/base.md): read them before
changing anything. They're a copy of `base.md` in `raine-works/agents`, kept current by its sync: change them there,
not here. Where this file is more specific, it wins.

@.raineworks/base.md

## This repository

Dev Container Features (Bun, Deno, Node.js) published to `ghcr.io/raine-works/devcontainer-features/<feature>`. How
it's laid out, tested and released: [docs/development.md](docs/development.md).

- **Every change to a feature bumps its `version`** in `src/<feature>/devcontainer-feature.json` (patch for a fix,
  minor for a new option, major for a breaking change): the release only publishes versions GHCR doesn't have, so an
  unbumped change never ships. The `Version bump` check fails a pull request that forgets.
- **Never edit a feature's `README.md`**: it's generated from `devcontainer-feature.json` on release. Hand-written notes
  go in `NOTES.md`; the guides in `docs/`.
- **Install scripts run as root at image build time** on Debian and Ubuntu: `set -e`, install a prerequisite only
  when it's missing (so images that have it are left alone), and fail with a clear message on an unsupported
  architecture or version.
- **Verify what you download** where upstream publishes a checksum (Node.js's `SHASUMS256.txt`); say in
  [docs/checksums.md](docs/checksums.md) what isn't verified.
- **A new option or behaviour gets a scenario** in `test/<feature>/scenarios.json` and its assertions script; pin the
  versions a scenario installs so it doesn't change under you.
- Releases, tags and GHCR publishing are the release workflow's; never publish or tag by hand.
