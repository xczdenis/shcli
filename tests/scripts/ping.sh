#!/usr/bin/env bash

source ./cli.sh

ping() {
    echo PONG
}

# ---------- Commands ----------
add_cmd ping "Ping. Correct response is PONG"

# ---------- Start ----------
cli_run "$@"