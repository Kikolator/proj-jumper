#!/usr/bin/env bats

@test "proj --help prints usage" {
  run zsh -c " \
    source \"$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"; \
    proj --help \
  "
  [ "$status" -eq 0 ]
  [[ "$output" == *Usage:* ]]
}