#!/usr/bin/env bash

list() {
  echo "current workspace path: $WORKSPACE_PATH" 1>&2
  ls $WORKSPACE_PATH
}
