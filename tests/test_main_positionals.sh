#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/main_with_args_and_positionals.sh --arg1=custom first second)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "ARG1=custom" "$actual" \
    "Should parse the global flag value before calling main"
assert_contains "POS=first" "$actual" \
    "Should forward the first positional argument to main"
assert_contains "POS=second" "$actual" \
    "Should forward the second positional argument to main"
