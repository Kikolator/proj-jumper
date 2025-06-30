#!/usr/bin/env bats

@test "proj-config appends PROJ_DEV_ROOT export to .zshrc" {
  temp_home=$(mktemp -d)
  export ZDOTDIR="$temp_home"
  touch "$ZDOTDIR/.zshrc"

  new_root=$(mktemp -d)

  run zsh -c " \
    source \"$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"; \
    proj-config '$new_root' \
  "

  [ "$status" -eq 0 ]
  grep -q "export PROJ_DEV_ROOT=$new_root" "$ZDOTDIR/.zshrc"
}