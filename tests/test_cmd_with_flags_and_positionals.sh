#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/add_cmd_with_global_and_args.sh --prefix=Hi greet --name=Jane extra-one extra-two)"
actual="$(printf '%s' "$output" | strip_colors)"

assert_contains "GLOBAL=Hi" "$actual" \
    "Should apply the global flag when executing a command"
assert_contains "NAME=Jane" "$actual" \
    "Should apply the command-specific flag when executing a command"
assert_contains "POS=extra-one" "$actual" \
    "Should forward the first leftover positional argument to the command"
assert_contains "POS=extra-two" "$actual" \
    "Should forward the second leftover positional argument to the command"
