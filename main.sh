#!/usr/bin/bash


source "$WORKSPACE_DIR/help.sh"

workspace() {
  case $1 in
    list | ls ) $WORKSPACE_DIR/lib/list.sh $WORKSPACE_PATH ;;

    init | i) shift; $WORKSPACE_DIR/lib/create.sh $WORKSPACE_PATH $@ ;;

    cd | go)
      shift;
      ruta=`$WORKSPACE_DIR/lib/go.sh $WORKSPACE_PATH $@`
      if [ ! -z "$ruta" ]; then
        cd $ruta
      else
        cd $WORKSPACE_PATH
        return 1
      fi
    ;;

    path)
      shift;
      ruta=`$WORKSPACE_DIR/lib/go.sh $WORKSPACE_PATH $@`
      if [ ! -z "$ruta" ]; then
        echo $ruta
        return 0
      else
        return 1
      fi
    ;;

    current)
      shift;
      $WORKSPACE_DIR/lib/current.sh $WORKSPACE_PATH $@
      return $?
      # local wrkPath=`realpath $WORKSPACE_PATH`
      # # echo $wrkPath
      # local a=`realpath --relative-to="$wrkPath" .`
      # list=(${a//\// })
      # echo ${list[0]}
     #   count=${#list[@]}
      # return 1
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
