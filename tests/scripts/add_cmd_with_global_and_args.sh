#!/usr/bin/env bash

source ./cli.sh

greet() {
    echo "GLOBAL=${CLI_ARG_PREFIX}"
    echo "NAME=${CLI_ARG_NAME}"
    for arg in "$@"; do
        echo "POS=${arg}"
    done
}

add_arg prefix "Hello" "Global greeting prefix"
add_cmd greet "Sends a greeting"
add_cmd_arg greet name "world" "Who to greet"

cli_run "$@"
