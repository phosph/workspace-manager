#!/usr/bin/env bash
# shellcheck source="./current.sh"
# shellcheck disable=SC2068
source "$PROGDIR/current.sh"

__print_execute_help() {
  cat <<EOF
uso: $PROGNAME exec <command> [..args]

ejecuta cualquier script bajo <CURRENT_WORKSPACE>/scrips/
EOF
}

execute() {

  case $1 in
    -h | --help ) __print_execute_help; return 0 ;;
  esac

  local -r script="$1"; shift
  local -r wrkPath="`current -p`";

  if [ -d "${wrkPath}/scripts" ] && [ -x "${wrkPath}/scripts/${script}" ]; then
    ${wrkPath}/scripts/${script} $@
  else
    echo "script $script was not found"
    return 1
  fi
}
