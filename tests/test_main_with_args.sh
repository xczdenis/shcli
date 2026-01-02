#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

# case 1
output="$(tests/scripts/main_with_args.sh)"

expected="INFO. arg1=''; arg2='default'"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"

# case 2
output="$(tests/scripts/main_with_args.sh --arg1="with space")"

expected="INFO. arg1='with space'; arg2='default'"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"

# case 3
output="$(tests/scripts/main_with_args.sh --arg2="with space")"

expected="INFO. arg1=''; arg2='with space'"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"

# case 4
output="$(tests/scripts/main_with_args.sh --arg1="with space 1" --arg2=value2)"

expected="INFO. arg1='with space 1'; arg2='value2'"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"

# case 5
output="$(tests/scripts/main_with_args.sh --arg2="with space 2" --arg1=value1)"

expected="INFO. arg1='value1'; arg2='with space 2'"
actual="$(printf '%s' "$output" | strip_colors)"

assert_eq "$expected" "$actual" \
    "Should print ${expected}"