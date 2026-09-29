# Ruby

Builds a base Ruby Docker image, configured through a `.env` file.

## What the image contains

- Ubuntu (`ubuntu:latest`) base
- [asdf](https://asdf-vm.com/) with the `nodejs`, `ruby` and `redis` plugins; the requested Ruby version is installed via asdf
- jemalloc, preloaded through `LD_PRELOAD`
- the PostgreSQL APT repository (PGDG) is configured, and the packages listed in `packages` are installed

Images are built for both `linux/amd64` and `linux/arm64` (see `docker-compose.yml`).

## Configuration

Set these variables in `.env`:

| Variable | Purpose |
| --- | --- |
| `image_prefix` | Image name; the tag is `<ruby_version>` (amd64) or `<ruby_version>-arm64` |
| `packages` | Space-separated APT packages to install |
| `ruby_version` | Ruby version installed via asdf |
| `asdf_version` | asdf release to download |

## Build

```sh
docker compose build          # both architectures
docker compose build amd64    # or just one: amd64 / arm64
```
