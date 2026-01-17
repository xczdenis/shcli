#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

before_cmd_output="$(tests/scripts/add_cmd_with_args.sh --name=Jane greet)"
before_cmd_actual="$(printf '%s' "$before_cmd_output" | strip_colors)"

assert_contains "Name: " "$before_cmd_actual" \
    "Should keep default name when flag appears before command"
assert_contains "Arg: --name=Jane" "$before_cmd_actual" \
    "Should treat pre-command flag as positional argument"

after_cmd_output="$(tests/scripts/add_cmd_with_args.sh greet --name=Jane)"
after_cmd_actual="$(printf '%s' "$after_cmd_output" | strip_colors)"

assert_contains "Name: Jane" "$after_cmd_actual" \
    "Should apply command flag when provided after command"
