#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/cmd_help_global_flags.sh greet --help)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "Global flags:" "$actual" \
    "Should include global flags section in command help"
assert_contains "--verbose" "$actual" \
    "Should include global flag in command help"
assert_contains "(default: 'false')" "$actual" \
    "Should include default value for global flag"
