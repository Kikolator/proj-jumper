@test "proj jumps into existing directory" {
  fake_root=$(mktemp -d)
  mkdir "$fake_root/alpha"
  export DEV_ROOT="$fake_root"
  run bash -c "source $BATS_TEST_DIRNAME/../proj-jumper.plugin.zsh; proj alpha; pwd"
  [ "$status" -eq 0 ]
  [[ "$output" == "$fake_root/alpha" ]]
}