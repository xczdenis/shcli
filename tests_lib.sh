#!/usr/bin/env bash
set -euo pipefail

# Shared helpers for test scripts.

# strip_colors: removes ANSI color escape sequences from input
strip_colors() {
    # This sed pattern removes ESC[...m sequences
    sed -E 's/\x1B\[[0-9;]*m//g'
}

# assert_eq expected actual message
assert_eq() {
    local expected="$1"
    local actual="$2"
    local message="${3:-}"

    if [[ "$expected" != "$actual" ]]; then
        echo "ASSERT_EQ FAILED: $message"
        echo "  expected: [$expected]"
        echo "  actual  : [$actual]"
        return 1
    fi
}

# assert_contains needle haystack message
assert_contains() {
    local needle="$1"
    local haystack="$2"
    local message="${3:-}"

    if ! printf '%s' "$haystack" | grep -q -- "$needle"; then
        echo "ASSERT_CONTAINS FAILED: $message"
        echo "  expected to find: [$needle]"
        echo "  in output:"
        printf '%s\n' "$haystack"
        return 1
    fi
}
