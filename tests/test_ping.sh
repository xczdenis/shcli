#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/ping.sh ping)"

expected="PONG"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"
