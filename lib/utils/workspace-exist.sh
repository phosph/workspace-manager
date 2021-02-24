#!/usr/bin/env bash

workspace-exits() {
  local -r wrkName="$1"

  if [ ! -z "$wrkName" ] && [ -d "$WORKSPACE_PATH/$wrkName" ]; then
    echo "$WORKSPACE_PATH/$wrkName"
    echo "$wrkName workspace exits" 1>&2
    return 0
  else
    echo "$wrkName workspace doesn't exits" 1>&2
    return 1
  fi
}
