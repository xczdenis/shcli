#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/unknown_command.sh nope 2>&1 || true)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "Error: unknown command" "$actual" \
    "Should report unknown command error"
assert_contains "Usage: unknown_command.sh <command>" "$actual" \
    "Should show short usage when command is unknown"
