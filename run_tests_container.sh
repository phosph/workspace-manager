#!/usr/bin/env bash
set -eo pipefail

# This script builds and runs the tests inside a container.
# It automatically detects and uses the first available
# container engine in the order: podman, docker.
# Incus is not supported as it uses a different workflow.

# Find the container engine
CONTAINER_CMD=""
if command -v podman &> /dev/null; then
    CONTAINER_CMD="podman"
elif command -v docker &> /dev/null; then
    CONTAINER_CMD="docker"
else
    echo "Error: No supported container engine found. Please install podman or docker." >&2
    exit 1
fi

echo "Using '$CONTAINER_CMD' to run containerized tests."


IMAGE_NAME="workspace-manager-tests"

echo "Building the container image for tests..."
"$CONTAINER_CMD" build -t "$IMAGE_NAME" -f Containerfile .

echo
echo "Running tests in a container..."
"$CONTAINER_CMD" run --rm "$IMAGE_NAME"
