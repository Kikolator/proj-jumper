#!/usr/bin/env bats

@test "proj jumps into existing directory" {
  fake_root=$(mktemp -d)
  mkdir "$fake_root/alpha"

  run zsh -c " \
    export DEV_ROOT='$fake_root'; \
    source \"$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"; \
    proj alpha; \
    pwd -P \
  "

  [ "$status" -eq 0 ]
  [[ "$output" == *"$fake_root/alpha"* ]]
}