#!/usr/bin/env bats

setup() {
  load '../test_helpers/load_plugin'   # tiny helper that sources the plugin
}

@test "proj --help prints usage" {
  run proj --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage:"* ]]
}