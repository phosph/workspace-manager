#!/usr/bin/env bash
# shellcheck disable=SC2068
# shellcheck source=./list.sh
# shellcheck source=./go.sh

__current_print_help() {
  cat <<EOF
uso:
    $PROGNAME current [--help|-h] [--inner|-i] [--show-name|-n] [--expand|-e] [--go|-g]

opciones:
   -n | --show-name   imprime el nombre del workspace actual
   -i | --inner       imprime el path relativo al workspace actual
   -e | --expand      se usa en conjunto con -i y -n, hace que la salida sea más descriptiva
   -h | --help        imprime este mensaje
   -p | --path        imprime la ruta del workspace actual
   -g | --go          alias de: $PROGNAME go <current-workspace> [...args]
EOF
}

currentName() {
  local -r wrkPath=`realpath $WORKSPACE_PATH`
  local -r name=`realpath --relative-to="$wrkPath" . | sed 's/\// /g' | awk '{print $1}'`
  if [ "$name" = '.' ]; then
    echo _base_
  elif [ "$name" = '..' ]; then
    echo
    return 1
  else
    source "$PROGDIR/list.sh"
    local -r list=`list $WORKSPACE_PATH 2>/dev/null`
    if [[ $list =~ (^|[[:space:]])"$name"($|[[:space:]]) ]]; then
      echo $name
      return 0
    else
      return 1
    fi
  fi

}

currentIn() {
  local -r wrkPath=`realpath $WORKSPACE_PATH`
  local -r name=`realpath --relative-to="$wrkPath" . | sed 's/\// /g' | awk '{print $1}'`

  if [ "$name" = '.' ] || [ "$name" = '..' ]; then
    return 1
  else
    source "$PROGDIR/list.sh"
    list=`list $WORKSPACE_PATH 2>/dev/null`
    if [[ $list =~ (^|[[:space:]])"$name"($|[[:space:]]) ]]; then
      realpath --relative-to="$wrkPath/$name" "`pwd`"
      return 0
    else
      return 1
    fi
  fi
}



current() {

  local arg=
  for arg in "$@"; do
    local delim=""
    case "$arg" in
      #translate --gnu-long-options to -g (short options)
      --inner     ) args+=" -i" ;;
      --show-name ) args+=" -n" ;;
      --expand    ) args+=" -e" ;;
      --help      ) args+=" -h" ;;
      --path      ) args+=" -p" ;;
      --go      ) args+=" -g" ;;
      #pass through anything else
      *) [[ "${arg:0:1}" == "-" ]] || delim="\""
        args+=" ${delim}${arg}${delim}";;
    esac
  done

  # Reset the positional parameters to the short options
  eval set -- $args

  local SHOW_NAME
  local SHOW_INNER_PATH
  local EXPANDED
  local AS_GO
  local PRINT_PATH

  # set -x
  while getopts "inehpg" OPTION; do
    case $OPTION in
      n) SHOW_NAME=1 ;;
      i) SHOW_INNER_PATH=1 ;;
      e) EXPANDED=1 ;;
      h) __current_print_help; exit 0 ;;
      p) PRINT_PATH=1 ;;
      g) AS_GO=1 ;;
      *) return 1 ;;
    esac
  done
  # set +x

  # if [[ ! "$SHOW_NAME" -eq 1 ]] && [[ ! "$SHOW_INNER_PATH" -eq 1 ]]; then
  #     AS_GO=1
  # fi

  if [[ "$PRINT_PATH" == 1 ]]; then
    source "$PROGDIR/go.sh"
    source "$PROGDIR/path.sh"

    local -r wrkSpaceName="`currentName`" || return 1

    path "$wrkSpaceName"
  elif [[ "$AS_GO" == 1 ]]; then
    source "$PROGDIR/go.sh"

    local -r wrkSpaceName="`currentName`" || return 1
    shift

    go_workspace "$wrkSpaceName" $@

  else
    if [[ "$SHOW_NAME" -eq 1 ]]; then
      if [[ "$EXPANDED" -eq 1 ]]; then printf "name:          "; fi
      currentName
    fi
    if [[ "$SHOW_INNER_PATH" -eq 1 ]]; then
      if [[ "$EXPANDED" -eq 1 ]]; then printf "relative path: "; fi
      currentIn
    fi
  fi


  return $?
}
