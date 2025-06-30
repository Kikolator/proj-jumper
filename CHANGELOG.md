# Changelog

All notable changes to **proj‑jumper** are documented in this file.<br>
This project follows the [Keep a Changelog](https://keepachangelog.com/) convention and uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- New Bats-core tests for CI coverage:

  - `proj_root_missing.bats`
  - `proj_unknown_project.bats`
  - `completion.bats`
  - `proj_config_sets_root.bats`

## [0.1.3] - 2025‑06‑30

### Added

- `proj --help` / `proj -h` now prints a detailed usage guide.

### Changed

- Refactored main function to route `--help` before directory checks.

## [0.1.2] - 2025‑06‑30

### Added

- `proj-config` helper command for one‑line root setup.
- Updated README with Homebrew‑only install instructions and config helper docs.

### Changed

- Homebrew caveats now remind users to set `PROJ_DEV_ROOT` or run `proj-config`.

## [0.1.1] - 2025‑06‑30

### Fixed

- Renamed `proj.plugin.zsh` → `proj-jumper.plugin.zsh` so Oh My Zsh can load the plugin without warnings.

## [0.1.0] - 2025‑06‑30

### Added

- Initial public release:

  - `proj` command with interactive picker and tab completion.
  - Smart root‑mount detection.
  - Homebrew tap formula and MIT license.
