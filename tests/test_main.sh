#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_SH="$PROJECT_ROOT/workspace.sh"

# Make workspace.sh available from project root
source <("$WORKSPACE_SH" init)

source "$PROJECT_ROOT/tests/test_helper.sh"

TEST_DIR=""
ORIGINAL_DIR=$(pwd)

setup() {
    TEST_DIR=$(mktemp -d)
    export WORKSPACE_ROOT="$TEST_DIR/ws_root"
    mkdir -p "$WORKSPACE_ROOT"
    echo "WORKSPACE_NAME=test_ws" > "$WORKSPACE_ROOT/.workspace"
}

teardown() {
    # Go back to original directory to be able to remove TEST_DIR
    cd "$ORIGINAL_DIR"
    rm -rf "$TEST_DIR"
}

test_create_workspace() {
    echo "--- Running test: ${FUNCNAME[0]} ---"
    local output
    local return_code
    set +e
    output=$("$WORKSPACE_SH" create test-project)
    return_code=$?
    set -e

    assert_equals "3" "$return_code" "create should return 3"
    assert_equals "$WORKSPACE_ROOT/test-project/core" "$output" "create should output the core path"
    assert_exists "$WORKSPACE_ROOT/test-project" "Workspace directory should be created"
    assert_exists "$WORKSPACE_ROOT/test-project/.wrkspace" ".wrkspace file should be created"
    assert_exists "$WORKSPACE_ROOT/test-project/core" "core directory should be created"
    assert_exists "$WORKSPACE_ROOT/test-project/doc" "doc directory should be created"

    local content
    content=$(cat "$WORKSPACE_ROOT/test-project/.wrkspace")
    assert_equals 'WORKSPACE="test-project"' "$content" ".wrkspace file content is wrong"
    echo "--- Test passed: ${FUNCNAME[0]} ---"
}

test_list_workspaces() {
    echo "--- Running test: ${FUNCNAME[0]} ---"
    # The create command returns 3, which would cause the script to exit.
    set +e
    "$WORKSPACE_SH" create project1 >/dev/null
    "$WORKSPACE_SH" create project2 >/dev/null
    set -e

    local output
    output=$("$WORKSPACE_SH" list)
    assert_contains "$output" "Workspaces in test_ws:" "list should show header"
    assert_contains "$output" "project1" "list should show project1"
    assert_contains "$output" "project2" "list should show project2"
    echo "--- Test passed: ${FUNCNAME[0]} ---"
}

test_path_workspace() {
    echo "--- Running test: ${FUNCNAME[0]} ---"
    set +e
    "$WORKSPACE_SH" create my-project > /dev/null
    set -e
    local path
    path=$("$WORKSPACE_SH" path my-project)
    assert_equals "$WORKSPACE_ROOT/my-project" "$path" "path should return the correct workspace path"

    cd "$WORKSPACE_ROOT/my-project/core"
    path=$("$WORKSPACE_SH" path -c)
    assert_equals "$WORKSPACE_ROOT/my-project" "$path" "path -c should return the current workspace path"
    echo "--- Test passed: ${FUNCNAME[0]} ---"
}

test_go_workspace() {
    echo "--- Running test: ${FUNCNAME[0]} ---"
    set +e
    "$WORKSPACE_SH" create my-project > /dev/null
    local path
    local return_code

    path=$("$WORKSPACE_SH" go my-project)
    return_code=$?
    set -e
    assert_equals "3" "$return_code" "go should return 3"
    assert_equals "$WORKSPACE_ROOT/my-project/core" "$path" "go should return the core path by default"

    set +e
    path=$("$WORKSPACE_SH" go my-project -z doc)
    return_code=$?
    set -e
    assert_equals "3" "$return_code" "go with zone should return 3"
    assert_equals "$WORKSPACE_ROOT/my-project/doc" "$path" "go should return the doc path when specified"

    set +e
    path=$("$WORKSPACE_SH" go /)
    return_code=$?
    set -e
    assert_equals "3" "$return_code" "go to root should return 3"
    assert_equals "$WORKSPACE_ROOT" "$path" "go to root should return workspace root path"
    echo "--- Test passed: ${FUNCNAME[0]} ---"
}

test_ps1() {
    echo "--- Running test: ${FUNCNAME[0]} ---"
    set +e
    "$WORKSPACE_SH" create my-project > /dev/null
    set -e

    cd "$WORKSPACE_ROOT"
    local ps1_out
    ps1_out=$("$WORKSPACE_SH" ps1)
    assert_equals "test_ws" "$ps1_out" "ps1 at root should be correct"

    cd "$WORKSPACE_ROOT/my-project/core"
    ps1_out=$("$WORKSPACE_SH" ps1)
    assert_equals "test_ws;my-project;core;" "$ps1_out" "ps1 in core should be correct"

    cd "$WORKSPACE_ROOT/my-project/doc"
    ps1_out=$("$WORKSPACE_SH" ps1)
    assert_equals "test_ws;my-project;doc;" "$ps1_out" "ps1 in doc should be correct"

    mkdir "$WORKSPACE_ROOT/my-project/core/sub"
    cd "$WORKSPACE_ROOT/my-project/core/sub"
    ps1_out=$("$WORKSPACE_SH" ps1)
    assert_equals "test_ws;my-project;core;sub" "$ps1_out" "ps1 in subdir should be correct"
    echo "--- Test passed: ${FUNCNAME[0]} ---"
}

# Main test runner
run_test() {
    local test_name="$1"
    setup
    # Run test in a subshell to isolate environment and directory changes
    (
        "$test_name"
    )
    local return_code=$?
    teardown

    if [ $return_code -ne 0 ]; then
        echo "!!! Test failed: $test_name !!!"
        exit 1
    fi
}

run_all_tests() {
    run_test test_create_workspace
    run_test test_list_workspaces
    run_test test_path_workspace
    run_test test_go_workspace
    run_test test_ps1
    echo
    echo "All tests passed!"
}

run_all_tests
