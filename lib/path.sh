workspaceExits() {
  if [ ! -z "$1" ] && [ -d "$WORKSPACE_PATH/$1" ]; then
    echo $WORKSPACE_PATH/$1
    echo "$1 workspace exits" 1>&2
    return 0
  else
    echo "$1 workspace doesn't exits" 1>&2
    return 1
  fi
}

path() {
  if workspaceExits $@ &>/dev/null; then
    ruta=`workspaceExits $@ 2>/dev/null`
    echo "$ruta"
    return 0
  else
    echo "mal" 1>&2
    return 1
  fi
}
