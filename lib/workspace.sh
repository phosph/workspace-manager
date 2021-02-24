workspace() {
  if [[ $WORKSPACE_PATH == '' ]]; then
    echo "\$WORKSPACE_PATH is not set"
    exit 1
  fi

  option=$1
  shift

  case $option in
    list | ls ) list $@ ;;

    init | i) create $@;;

    cd | go) goWorkspace $@ ;;

    rmEnv) setWorkspaceScripts remove $@ ;;

    addEnv) setWorkspaceScripts add $@ ;;

    path) path $@ ;;

    current) current $@ ;;

    -h ) print_help ;;

    * ) echo 'workspace -h' 1>&2 ;;
  esac

  return $?
}
