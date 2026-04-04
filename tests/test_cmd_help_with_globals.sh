#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/add_cmd_with_global_and_args.sh greet --help)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "Usage: add_cmd_with_global_and_args.sh greet" "$actual" \
    "Should show usage for the specific command"
assert_contains "Flags:" "$actual" \
    "Should show the command-specific flags section"
assert_contains "--name" "$actual" \
    "Should include the command-specific flag in help"
assert_contains "Global flags:" "$actual" \
    "Should show the global flags section in command help"
assert_contains "--prefix" "$actual" \
    "Should include the global flag in command help"
