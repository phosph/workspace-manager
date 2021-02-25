#!/usr/bin/env bash

# shellcheck source="./utils/workspace-exits"
source "$PROGDIR/utils/workspace-exist.sh"

path() {
  local -r WORKSPACE_NAME="$1"
  if workspace-exits $WORKSPACE_NAME &>/dev/null; then
    ruta=`workspace-exits $WORKSPACE_NAME 2>/dev/null`
    echo "$ruta"
    return 0
  else
    echo "mal" 1>&2
    return 1
  fi
}
