#!/usr/bin/env bash

source ./cli.sh

greet() {
    echo "Greeting command"
}

add_arg verbose false "Enable verbose output"
add_cmd greet "Sends a greeting"

cli_run "$@"
