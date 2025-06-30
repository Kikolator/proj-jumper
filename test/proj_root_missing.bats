#!/usr/bin/env bats

load 'test_helper/bats-support/load'  # optional if bats-support is available
load 'test_helper/bats-assert/load'   # optional if bats-assert is available

@test "proj warns and exits 1 when DEV_ROOT is missing" {
  missing_root="$(mktemp -d)"
  rmdir "$missing_root"        # ensure the directory truly does not exist

  run zsh -c "
    export DEV_ROOT='$missing_root'
    source \"\$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"
    proj
  "

  [ "$status" -eq 1 ]
  [[ "$output" == ⚠️* ]] || [[ "$output" == *'not found'* ]]
}
