#!/usr/bin/env bash

source ./cli.sh

main() {
    echo "VERBOSE=${CLI_ARG_VERBOSE}"
    for arg in "$@"; do
        echo "ARG=${arg}"
    done
}

add_arg verbose "false" "Enable verbose output"

cli_run "$@"
