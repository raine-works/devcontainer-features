
# Bun (bun)

Install the Bun JavaScript runtime.

## Example Usage

```json
"features": {
    "ghcr.io/raine-works/devcontainer-features/bun:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Bun version. | string | latest |

## Notes

- Installs Bun to `/usr/local/bin`, so it is on `PATH` for all users.
- Requires a Debian/Ubuntu based image (`apt-get` is used to fetch `curl` and `unzip` when missing).
- `version` takes a bare version such as `1.2.0`; the release-tag prefix is added for you.

## Support

If this feature saves you time, you can support its upkeep:

<a href="https://buymeacoffee.com/raineworks"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-FFDD00?style=for-the-badge&logo=buymeacoffee&logoColor=black" alt="Buy Me a Coffee" /></a>


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/raine-works/devcontainer-features/blob/main/src/bun/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
