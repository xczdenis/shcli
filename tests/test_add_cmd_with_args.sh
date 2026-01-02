#!/usr/bin/env bash
set -euo pipefail

source "tests_lib.sh"

# case 1 - general help should mention the command name
help_output="$(tests/scripts/add_cmd_with_args.sh --help)"
help_actual="$(printf '%s' "$help_output" | strip_colors)"

expected="  greet   Sends a greeting"
actual="$(printf '%s' "$help_actual" | grep -E -- "greet[[:space:]]+Sends a greeting")"
assert_eq "$expected" "$actual" \
    "General help should list the command name and description"

# case 2 - command help should list command-specific arguments
cmd_help_output="$(tests/scripts/add_cmd_with_args.sh greet --help)"
cmd_help_actual="$(printf '%s' "$cmd_help_output" | strip_colors)"

expected="  --name      Who to greet (default: '')"
actual="$(printf '%s' "$cmd_help_actual" | grep -E -- "--name[[:space:]]+Who to greet")"
assert_eq "$expected" "$actual" \
    "Command help should describe the name flag with its default"

expected="  --message   Greeting message (default: 'default message value')"
actual="$(printf '%s' "$cmd_help_actual" | grep -E -- "--message[[:space:]]+Greeting message")"
assert_eq "$expected" "$actual" \
    "Command help should describe the message flag with its default"

# case 3 - function should receive argument without default when provided with spaces
with_name_output="$(tests/scripts/add_cmd_with_args.sh greet --name="Jane Doe")"
with_name_actual="$(printf '%s' "$with_name_output" | strip_colors)"

expected="Greeting command
Name: Jane Doe
Message: default message value"
actual="$(printf '%s' "$with_name_actual" | head -n 3)"
assert_eq "$expected" "$actual" \
    "Should inject provided name with spaces and keep default message"

# case 4 - function should respect default value with spaces when not overridden
with_default_message_output="$(tests/scripts/add_cmd_with_args.sh greet --name="John Smith")"
with_default_message_actual="$(printf '%s' "$with_default_message_output" | strip_colors)"

expected="Message: default message value"
actual="$(printf '%s' "$with_default_message_actual" | grep "^Message:")"
assert_eq "$expected" "$actual" \
    "Should use message default containing spaces when none provided"

# case 5 - function should apply custom value with spaces over default
custom_message_output="$(tests/scripts/add_cmd_with_args.sh greet --name="John Smith" --message="hello world message")"
custom_message_actual="$(printf '%s' "$custom_message_output" | strip_colors)"

expected="Name: John Smith"
actual="$(printf '%s' "$custom_message_actual" | grep "^Name:")"
assert_eq "$expected" "$actual" \
    "Should override default name with custom spaced value"

expected="Message: hello world message"
actual="$(printf '%s' "$custom_message_actual" | grep "^Message:")"
assert_eq "$expected" "$actual" \
    "Should override default message with custom spaced value"