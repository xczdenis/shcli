#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/no_main_no_cmd.sh)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "Error: unknown command" "$actual" \
    "Should print an error when no command and no main are available"
assert_contains "Usage: no_main_no_cmd.sh <command>" "$actual" \
    "Should print short command-oriented help after the error"
