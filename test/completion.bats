#!/usr/bin/env bats

@test "_proj_complete suggests directories in DEV_ROOT" {
  fake_root=$(mktemp -d)
  mkdir "$fake_root/alpha" "$fake_root/beta"

  run zsh -c " \
    export DEV_ROOT='$fake_root'; \
    source \"$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"; \
    reply=(); \
    _proj_complete \"\"; \
    print -l \"\${reply[@]}\" \
  "

  [ "$status" -eq 0 ]
  [[ "$output" == *alpha* ]]
  [[ "$output" == *beta* ]]
}