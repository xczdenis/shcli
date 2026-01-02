#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

output="$(tests/scripts/main_no_args.sh)"

expected="Some test information"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"