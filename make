#!/usr/bin/env bash

# Demo script for cli.sh.
# Shows:
# - basic run: ./make
# - positional args: ./make "arg1" "arg2"
# - command: ./make echo_line "text"
# - command with named args: ./make build demo --target=prod --optimize=true

source ./cli.sh

print_section() {
    local title="$1"
    echo
    echo "=== ${title} ==="
}

main() {
    print_section "Main flow"
    local first="${1:-<not provided>}"
    local second="${2:-<not provided>}"

    echo "Positional arguments:"
    echo "  1: ${first}"
    echo "  2: ${second}"

    echo "Global flag --greeting: ${CLI_ARG_GREETING}"
    echo "Try: ./make \"arg1\" \"arg2\" --greeting=Howdy"
    echo "Available commands: echo_line, build (see --help for details)."
}

add_arg greeting "Hello" "How to greet the user"

add_cmd echo_line "Echoes a line and adds a mood"
add_cmd_arg echo_line mood "cheerfully" "Mood description"

echo_line() {
    print_section "echo_line command"
    local text="${1:-<empty>}"
    echo "Greeting: ${CLI_ARG_GREETING}"
    echo "Text: ${text}"
    echo "Mood (--mood): ${CLI_ARG_MOOD}"
    echo "Change mood: ./make echo_line \"this CLI\" --mood=excited"
}

add_cmd build "Build a project with named flags"
add_cmd_arg build target "debug" "Build target (debug|prod)"
add_cmd_arg build optimize "false" "Enable optimizations"

build() {
    print_section "build command"
    local name="${1:-demo}"

    echo "Building '${name}'"
    echo "Target (--target): ${CLI_ARG_TARGET} (default: debug)"
    echo "Optimize (--optimize): ${CLI_ARG_OPTIMIZE} (default: false)"
    echo "Example: ./make build ${name} --target=prod --optimize=true"

    if [[ "${CLI_ARG_OPTIMIZE}" == "true" ]]; then
        echo "Optimizations enabled - using release flags."
    else
        echo "Optimizations disabled - using simpler build."
    fi
}

cli_run "$@"
