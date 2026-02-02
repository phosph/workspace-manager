#!/usr/bin/env bash

assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="$3"

    if [ "$expected" != "$actual" ]; then
        echo "Assertion failed: $message"
        echo "Expected: '$expected'"
        echo "Actual:   '$actual'"
        exit 1
    fi
}

assert_exists() {
    local path="$1"
    local message="$2"

    if [ ! -e "$path" ]; then
        echo "Assertion failed: $message"
        echo "Path does not exist: $path"
        exit 1
    fi
}

assert_contains() {
    local string="$1"
    local substring="$2"
    local message="$3"
    if [[ "$string" != *"$substring"* ]]; then
        echo "Assertion failed: $message"
        echo "Expected '$string' to contain '$substring'"
        exit 1
    fi
}
