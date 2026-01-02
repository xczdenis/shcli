#!/usr/bin/env bash
source ./cli.sh

hello() {
    echo "Hello command"
    for arg in "$@"; do
        echo "Arg: $arg"
    done
}

main() {
    echo "Main executed"
}
# ---------- Commands ----------
add_cmd hello "Prints a greeting"
# ---------- Start ----------
cli_run "$@"
