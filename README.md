# proj‑jumper

**proj‑jumper** is a lightweight Z‑shell plugin that lets you jump straight into any project folder under a single development root -- perfect when that root lives on a removable drive.

```text
proj listy        # → /Volumes/dog_house/development/projects/listy
proj              # fuzzy‑pick a project (needs fzf)
proj config ~/code # one‑time helper to set a different root
```

--------------------------------------------------------------------------------

## Features

- **Smart root check** – warns if the volume isn't mounted instead of failing.
- **One‑word `proj <name>`** – faster than typing long paths.
- **Interactive picker** – choose from a fuzzy list when you just run `proj` (uses **fzf** if available).
- **Tab completion** – `proj sa<Tab>` → `proj savage`.
- **Config helper** – `proj config /path` adds `export PROJ_DEV_ROOT=/path` to your `.zshrc`.

--------------------------------------------------------------------------------

## Installation (macOS Homebrew)

```sh
brew tap kikolator/proj
brew install proj-jumper
```

### Enable in Oh My Zsh

```sh
# one‑time link
ln -s "$(brew --prefix)/opt/proj-jumper/share/proj-jumper" \
      "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/proj-jumper"

# add the plugin name to ~/.zshrc, then reload
plugins=(... proj-jumper)
source ~/.zshrc
```

> _proj‑jumper works with any Z‑plugin manager that honours `_.plugin.zsh` files,<br>
> but Homebrew is the only distribution channel for now.*

--------------------------------------------------------------------------------

## Usage

Action                 | Command              | Result
---------------------- | -------------------- | ------------------------------------------------
Jump to a project      | `proj savage`        | `cd` into _savage_
Pick interactively     | `proj`               | fuzzy list via **fzf**
List projects (no fzf) | `proj`               | prints directory names
Tab‑complete           | `proj li<Tab>`       | expands to _listy_
Set a new root         | `proj config ~/code` | writes `export PROJ_DEV_ROOT=~/code` to `.zshrc`

### Environment variables

Variable        | Purpose
--------------- | ------------------------------------------------
`PROJ_DEV_ROOT` | Override the default root (`$HOME/development`).

--------------------------------------------------------------------------------

## Requirements

- Zsh 5.0+
- Optional: [`fzf`](https://github.com/junegunn/fzf) for the interactive picker.

--------------------------------------------------------------------------------

## License

[MIT](LICENSE) © 2025 Kikolator
