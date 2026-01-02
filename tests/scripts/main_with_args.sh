#!/usr/bin/env bash

source ./cli.sh

main() {
    arg1=${CLI_ARG_ARG1}
    arg2=${CLI_ARG_ARG2}
    echo "INFO. arg1='${arg1}'; arg2='${arg2}'"
}

# ---------- Commands ----------
add_arg arg1 "" "Parameter 1"
add_arg arg2 "default" "Parameter 2"


# ---------- Start ----------
cli_run "$@"