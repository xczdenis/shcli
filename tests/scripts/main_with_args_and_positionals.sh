#!/usr/bin/env bash

source ./cli.sh

main() {
    echo "ARG1=${CLI_ARG_ARG1}"
    for arg in "$@"; do
        echo "POS=${arg}"
    done
}

add_arg arg1 "default" "Parameter 1"

cli_run "$@"
