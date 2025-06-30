#!/usr/bin/env zsh
# proj-jumper — jump to a project inside $DEV_ROOT

# --- configuration ----------------------------------------------------------
: ${DEV_ROOT:=${PROJ_DEV_ROOT:-"/Volumes/dog_house/development/projects"}}

# allow users to export PROJ_DEV_ROOT or DEV_ROOT to override
export DEV_ROOT

# --- function ---------------------------------------------------------------
proj () {
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

# ---------------------------------- config helper
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

# --- completion hook --------------------------------------------------------
# Late-bound because the volume could mount after shell start
_proj_complete () {
  [[ -d $DEV_ROOT ]] || return
  compadd -- $(command ls -1 "$DEV_ROOT")
}
compdef _proj_complete proj