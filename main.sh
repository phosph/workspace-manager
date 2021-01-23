#!/usr/bin/bash


source "$WORKSPACE_DIR/help.sh"

workspace() {
  option=$1
  shift
  case $option in
    list | ls ) $WORKSPACE_DIR/lib/list.sh $WORKSPACE_PATH ;;

    init | i) $WORKSPACE_DIR/lib/create.sh $WORKSPACE_PATH $@ ;;

    cd | go)
      ruta=`$WORKSPACE_DIR/lib/go.sh $WORKSPACE_PATH $@`
      if [ ! -z "$ruta" ]; then
        cd $ruta
        newPath=`$WORKSPACE_DIR/lib/add-remove-path.sh add $WORKSPACE_PATH $@`
        if [ ! -z "$newPath" ]; then
          export PATH="$newPath"
        fi
      else
        cd $WORKSPACE_PATH
        return 1
      fi
    ;;

    exit)
      newPath=`$WORKSPACE_DIR/lib/add-remove-path.sh remove $WORKSPACE_PATH`
      if [ ! -z "$newPath" ]; then
        export PATH="$newPath"
      fi
    ;;
    addEnv)
      newPath=`$WORKSPACE_DIR/lib/add-remove-path.sh add $WORKSPACE_PATH $@`
      if [ ! -z "$newPath" ]; then
        export PATH="$newPath"
      fi
    ;;

    path)
      ruta=`$WORKSPACE_DIR/lib/go.sh $WORKSPACE_PATH $@`
      if [ ! -z "$ruta" ]; then
        echo $ruta
        return 0
      else
        return 1
      fi
    ;;

    current)
      $WORKSPACE_DIR/lib/current.sh $WORKSPACE_PATH $@
      return $?
    ;;

    --help | -h ) _workspace_help ;;

    help)
      case "$2" in
        init | i ) ./lib/create.sh -h ;;
        *        ) _workspace_help ;;
      esac
    ;;

    *)
      _workspace_help;
      cd $WORKSPACE_PATH
    ;;
  esac

  return 0
}

export -f workspace
