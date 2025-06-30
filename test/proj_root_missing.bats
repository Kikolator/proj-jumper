#!/usr/bin/env bats

@test "proj warns and exits 1 when DEV_ROOT is missing" {
  missing_root="$(mktemp -d)"
  rmdir "$missing_root"

  run zsh -c "
    export DEV_ROOT='$missing_root'
    source \"\$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"
    proj
  "

  [ \"\$status\" -eq 1 ]
  [[ \"\$output\" == ⚠️* ]] || [[ \"\$output\" == *'not found'* ]]
}
