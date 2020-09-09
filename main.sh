#!/usr/bin/bash

if [ -z "$WORKSPACE_PATH" ]; then
  export WORKSPACE_PATH="$HOME/Work"
fi

source "$WORKSPACE_DIR/help.sh"

_workspace_init() {
  cd $WORKSPACE_PATH;

  new_workspace="$1"
  shift;

  mkdir -p $new_workspace/{core,doc}
  tree $new_workspace
  cd "$new_workspace/core"

  if [ ! -z "$1" ]
  then
    case $1 in
      --repo | -r)
        if [ ! -z "$2" ]; then
          git clone $2
          a=(`ls ./`)
          cd "${a[0]}"
          if [ -f "./package.json" ]; then
            if [ -f "./yarn.lock" ]; then
              yarn install
            elif [ -f "package-lock.json" ]; then
              npm i
            fi
          fi
          shift
          shift
        fi
      ;;
    esac
  fi

  return 0
}

_workspace_cd() {
  if [ ! -z "$1" ] && [ -d "$WORKSPACE_PATH/$1" ]; then

    ruta="$WORKSPACE_PATH/$1"

    if [ ! -z "$2" ] && [ -d "$ruta/$2" ]; then
      ruta="$ruta/$2"
    else
      ruta="$ruta/core"
    fi

    cd $ruta

  else

    cd "$WORKSPACE_PATH"

  fi

  return 0
}

workspace() {

  case $1 in
    --help | -h ) _workspace_help ;;

    init | i) shift; _workspace_init $@ ;;

    cd | go) shift; _workspace_cd $@ ;;

    help)
      case "$2" in
        init | i ) _workspace_init_help ;;
        *        ) _workspace_help
      esac
      ;;

    *) _workspace_help; return 1 ;;
  esac

}

export -f workspace
