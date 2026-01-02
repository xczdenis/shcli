#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

main_output="$(tests/scripts/add_cmd_no_args.sh)"
main_actual="$(printf '%s' "$main_output" | strip_colors)"

assert_eq "Main executed" "$main_actual" \
    "Should fall back to main when no command is provided"

general_help_output="$(tests/scripts/add_cmd_no_args.sh --help)"
general_help_actual="$(printf '%s' "$general_help_output" | strip_colors)"

assert_contains "Usage: add_cmd_no_args.sh <command>" "$general_help_actual" \
    "Should show general usage for commands"
assert_contains "Commands:" "$general_help_actual" \
    "Should list commands in general help"
assert_contains "hello   Prints a greeting" "$general_help_actual" \
    "Should include command description in help"

command_help_output="$(tests/scripts/add_cmd_no_args.sh hello --help)"
command_help_actual="$(printf '%s' "$command_help_output" | strip_colors)"

assert_contains "Usage: add_cmd_no_args.sh hello" "$command_help_actual" \
    "Should show usage for the specific command"
assert_contains "hello - Prints a greeting" "$command_help_actual" \
    "Should include command-specific description"

positive_output="$(tests/scripts/add_cmd_no_args.sh hello)"
positive_actual="$(printf '%s' "$positive_output" | strip_colors)"

assert_eq "Hello command" "$positive_actual" \
    "Should execute the registered command when provided"

with_args_output="$(tests/scripts/add_cmd_no_args.sh hello "argument 1" "argument 2")"
with_args_actual="$(printf '%s' "$with_args_output" | strip_colors)"

assert_contains "Hello command" "$with_args_actual" \
    "Should print base command output when called with arguments"
assert_contains "Arg: argument 1" "$with_args_actual" \
    "Should forward first argument to command"
assert_contains "Arg: argument 2" "$with_args_actual" \
    "Should forward second argument to command"
