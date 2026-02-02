#!/usr/bin/env bash
set -eo pipefail

# This script is designed to be run from the root of the project.
# It executes the main test file.

echo "Running workspace-manager tests..."
bash tests/test_main.sh
