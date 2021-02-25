#!/usr/bin/env bash
# shellcheck source="./utils/workspace-exits"

source "$PROGDIR/utils/workspace-exist.sh"

__go_print_help() {
  cat <<EOF
  usage: $PROGNAME go WORKSPACE_NAME [location]

  location:
    core | core/..
    doc | doc/..
    ...
EOF
}

go_workspace() {

  while getopts "h" OPTION; do
    case $OPTION in
      h) __go_print_help; exit 0;;
      *) return 1 ;;
    esac
  done

  if workspace-exits $1 &>/dev/null; then
    local -r wrkPathInner="$2"
    local -r wrkName="$1"
    local wrkPath

    wrkPath=`workspace-exits $wrkName 2>/dev/null`


    if [ ! -z "$wrkPathInner" ] && [ -d "$wrkPath/$wrkPathInner" ]; then
      wrkPath="$wrkPath/$wrkPathInner"
    elif [ -d "$wrkPath/core" ]; then
      # local wrkPath
      wrkPath="$wrkPath/core"

      mapfile -t listFiles < <(ls $wrkPath)
      if [ ${#listFiles[@]} = 1 ]; then
        wrkPath="$wrkPath/${listFiles[0]}"
      fi
    fi



    echo "cd $wrkPath"

    return 0
  else
    return 1
  fi
}
