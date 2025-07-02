#!/usr/bin/env zsh
# proj-jumper — jump quickly into a project directory under $DEV_ROOT
# v0.1.4-dev

# -------- configuration ------
# A single variable controls the root; fallback is ~/development.
: ${PROJ_DEV_ROOT:="$HOME/development"}

# ───────── help text ─────────
_proj_usage() {
  cat <<EOF
proj-jumper — jump to project directories

Usage:
  proj <name>          cd into the project called <name>
  proj config <dir>    set PROJ_DEV_ROOT to <dir> and save it in ~/.zshrc
  proj                 interactive picker (fzf if available, else list)
  proj -h | --help     show this help

Options:
  -h, --help           display this help and exit

Environment variables:
  PROJ_DEV_ROOT        override the default root path ($PROJ_DEV_ROOT)

Examples:
  proj savage          → cd \$PROJ_DEV_ROOT/savage
  proj                 → fuzzy-select a project
  proj config ~/code   → write export PROJ_DEV_ROOT=~/code to ~/.zshrc
EOF
}


# ───────── main command ─────────
proj () {
  # 0. help first
  [[ "$1" == "-h" || "$1" == "--help" ]] && { _proj_usage; return 0 }

  # configure root
  if [[ "$1" == "config" ]]; then
    local new_root=$2
    if [[ -z $new_root ]]; then
      print -u2 "Usage: proj config /path/to/root"
      return 1
    fi
    [[ -d $new_root ]] || { print -u2 "Directory does not exist: $new_root"; return 1; }

    export PROJ_DEV_ROOT="$new_root"
    local rcfile=${ZDOTDIR:-$HOME}/.zshrc
    sed -i '' '/^export PROJ_DEV_ROOT=/d' "$rcfile"
    echo "export PROJ_DEV_ROOT=$new_root" >>"$rcfile"
    print "PROJ_DEV_ROOT set to $new_root (added to $rcfile)."
    print "Restart your shell or run: source $rcfile"
    return 0
  fi

  local root="${PROJ_DEV_ROOT:-$HOME/development}"


  # 1. verify disk
  [[ -d $root ]] || { print -u2 "⚠️ $root not found"; return 1 }

  # 2. arg-aware behaviour
  if [[ -z $1 ]]; then
    # no arg → interactive picker if fzf present, else list
    if command -v fzf >/dev/null; then
      local sel
      sel=$(command ls -1 "$root" | fzf --prompt='project> ')
      [[ -n $sel ]] && cd "$root/$sel"
    else
      print "Projects:"; command ls "$root"
    fi
  else
    # arg → direct cd with safety
    local target="$root/$1"
    [[ -d $target ]] && cd "$target" || {
      print -u2 "No such project: $1"; return 1
    }
  fi
}

# ─────── completion helpers ───────
# Late-bound because the volume could mount after shell start
_proj_complete () {
  local root="${PROJ_DEV_ROOT:-$HOME/development}"
  [[ -d $root ]] || returncompadd -- $(command ls -1 "$root")
}
compdef _proj_complete proj