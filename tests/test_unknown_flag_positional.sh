#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/add_cmd_no_args.sh hello --unknown --another=value)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "Arg: --unknown" "$actual" \
    "Should forward unknown flag without value as positional argument"
assert_contains "Arg: --another=value" "$actual" \
    "Should forward unknown flag with value as positional argument"
