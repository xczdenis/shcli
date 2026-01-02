#!/usr/bin/env bash
set -euo pipefail

# Simple test runner for CLI framework.
# It discovers and executes all *.sh test scripts from the ./tests directory.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TESTS_DIR="$ROOT_DIR/tests"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [[ ! -d "$TESTS_DIR" ]]; then
    echo "Tests directory not found: $TESTS_DIR"
    exit 1
fi

total_tests=0
passed_tests=0
failed_tests=0

# Enable nullglob so the pattern expands to nothing if no files found
shopt -s nullglob
test_files=( "$TESTS_DIR"/*.sh )
shopt -u nullglob

if [[ ${#test_files[@]} -eq 0 ]]; then
    echo "No test files found in $TESTS_DIR"
    exit 1
fi

echo
echo -e "${GREEN}=====================${NC}"
echo -e "${GREEN}Starting CLI tests...${NC}"
echo -e "${GREEN}=====================${NC}"
echo

for test_file in "${test_files[@]}"; do
    ((++total_tests))
    test_name="$(basename "$test_file")"
    echo -e "${YELLOW}Running test: ${test_name}${NC}"
    # Always run tests with bash to keep behavior consistent
    if bash "$test_file"; then
        ((++passed_tests))
        echo -e "${GREEN}✓ PASS: $test_name${NC}"
    else
        ((++failed_tests))
        echo -e "${RED}✗ FAIL: $test_name${NC}"
    fi
    echo
done


echo "========================================"
echo -e "${YELLOW}Test Results:${NC}"
echo -e "Total:  $total_tests"
echo -e "${GREEN}Passed: $passed_tests${NC}"
if [ $failed_tests -gt 0 ]; then
    echo -e "${RED}Failed: $failed_tests${NC}"
else
    echo -e "${GREEN}Failed: $failed_tests${NC}"
fi

if [[ $failed_tests -ne 0 ]]; then
    echo "Some tests FAILED"
    exit 1
else
    echo "All tests PASSED"
fi
