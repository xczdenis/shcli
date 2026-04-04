#!/usr/bin/env bash

source ./cli.sh

hello() {
    echo "Hello command"
}

add_cmd hello "Prints a greeting"

cli_run "$@"
