#!/usr/bin/env bats

@test "proj exits 1 and warns when project does not exist" {
  fake_root="$(mktemp -d)"
  mkdir "$fake_root/alpha"

  run zsh -c "
    export DEV_ROOT='$fake_root'
    source \"\$BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh\"
    proj doesnotexist
  "

  [ \"\$status\" -eq 1 ]
  [[ \"\$output\" == *'No such project'* ]]
}
