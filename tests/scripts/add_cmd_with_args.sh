#!/usr/bin/env bash
source ./cli.sh

greet() {
    echo "Greeting command"
    echo "Name: ${CLI_ARG_NAME}"
    echo "Message: ${CLI_ARG_MESSAGE}"
    for arg in "$@"; do
        echo "Arg: $arg"
    done
}

add_cmd greet "Sends a greeting"
add_cmd_arg greet name "" "Who to greet"
add_cmd_arg greet message "default message value" "Greeting message"

cli_run "$@"
