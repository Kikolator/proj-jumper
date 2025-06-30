#!/usr/bin/env zsh
# proj-jumper — jump quickly into a project directory under $DEV_ROOT
# v0.1.3-dev

# -------- configuration ------
: ${DEV_ROOT:=${PROJ_DEV_ROOT:-"~/development"}}
# allow users to export PROJ_DEV_ROOT or DEV_ROOT to override
export DEV_ROOT

# ───────── help text ─────────
_proj_usage() {
  cat <<EOF
proj-jumper — jump to project directories

Usage:
  proj <name>          cd into the project called <name>
  proj                 interactive picker (fzf if available, else list)
  proj -h | --help     show this help

Options:
  -h, --help           display this help and exit

Environment variables:
  PROJ_DEV_ROOT        override the default root path ($DEV_ROOT)
  DEV_ROOT             same as above (kept for compatibility)

Examples:
  proj savage          → cd \$DEV_ROOT/savage
  proj                 → fuzzy-select a project
  proj-config ~/code   → write export PROJ_DEV_ROOT=~/code to ~/.zshrc
EOF
}


# ───────── main command ─────────
proj () {
  # 0. help first
  [[ "$1" == "-h" || "$1" == "--help" ]] && { _proj_usage; return 0 }

  # 1. verify disk
  [[ -d $DEV_ROOT ]] || { print -u2 "⚠️ $DEV_ROOT not found"; return 1 }

  # 2. arg-aware behaviour
  if [[ -z $1 ]]; then
    # no arg → interactive picker if fzf present, else list
    if command -v fzf >/dev/null; then
      local sel
      sel=$(command ls -1 "$DEV_ROOT" | fzf --prompt='project> ')
      [[ -n $sel ]] && cd "$DEV_ROOT/$sel"
    else
      print "Projects:"; command ls "$DEV_ROOT"
    fi
  else
    # arg → direct cd with safety
    local target="$DEV_ROOT/$1"
    [[ -d $target ]] && cd "$target" || {
      print -u2 "No such project: $1"; return 1
    }
  fi
}

# ───────── config helper ─────────
proj-config () {
  local new_root=${1:-}
  [[ -z $new_root ]] && {
    print -u2 "Usage: proj-config /path/to/root"
    return 1
  }
  if [[ ! -d $new_root ]]; then
    print -u2 "Directory does not exist: $new_root"
    return 1
  fi

  local rcfile=${ZDOTDIR:-$HOME}/.zshrc
  # strip any existing line that sets the var, then append the new one
  sed -i '' '/^export PROJ_DEV_ROOT=/d' "$rcfile"
  echo "export PROJ_DEV_ROOT=$new_root" >>"$rcfile"
  print "PROJ_DEV_ROOT set to $new_root (added to $rcfile)."
  print "Restart your shell or run: source $rcfile"
}
compdef _files proj-config   # tab-complete directories

# ─────── completion helpers ───────
# Late-bound because the volume could mount after shell start
_proj_complete () {
  [[ -d $DEV_ROOT ]] || return
  compadd -- $(command ls -1 "$DEV_ROOT")
}
compdef _proj_complete proj