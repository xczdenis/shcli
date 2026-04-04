#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

# case 1 - boolean flag without explicit value should become true
bool_output="$(tests/scripts/main_flag_behaviour.sh --verbose)"
bool_actual="$(printf '%s' "$bool_output" | strip_colors)"

assert_contains "VERBOSE=true" "$bool_actual" \
    "Should treat a present global flag without value as true"

# case 2 - unknown flags should be forwarded as positional arguments
unknown_output="$(tests/scripts/main_flag_behaviour.sh --mystery-flag value1)"
unknown_actual="$(printf '%s' "$unknown_output" | strip_colors)"

assert_contains "VERBOSE=false" "$unknown_actual" \
    "Unknown flags should not mutate known global flag values"
assert_contains "ARG=--mystery-flag" "$unknown_actual" \
    "Unknown flag token should be forwarded to main as a positional argument"
assert_contains "ARG=value1" "$unknown_actual" \
    "Arguments following an unknown flag should remain positional"
