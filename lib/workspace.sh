#!/usr/bin/env bash
# shellcheck disable=SC2068
# shellcheck source="./list.sh"
# shellcheck source="./create.sh"
# shellcheck source="./go.sh"
# shellcheck source="./path.sh"
# shellcheck source="./current.sh"
# shellcheck source="./help.sh"
# shellcheck source="./execute.sh"
# shellcheck source="./create_env.sh"
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m "$(dirname $0)")

source "$PROGDIR/list.sh"
source "$PROGDIR/create.sh"
source "$PROGDIR/go.sh"
source "$PROGDIR/path.sh"
source "$PROGDIR/current.sh"
source "$PROGDIR/help.sh"
source "$PROGDIR/execute.sh"
source "$PROGDIR/create_env.sh"


# if [[ $WORKSPACE_PATH == '' ]]; then
#   echo "\$WORKSPACE_PATH is not set"
#   exit 1
# fi

OPTION=$1
shift

case $OPTION in
  # rmEnv     ) setWorkspaceScripts remove $@ ;;
  # addEnv    ) setWorkspaceScripts add $@ ;;
  create       ) create $@ ;;
  -l | list    ) list $@ ;;
  -g | go      ) go_workspace $@ ;;
  -p | path    ) path $@ ;;
  -c | current ) current $@ ;;
  -e | exec    ) execute $@ ;;
  env          ) create_env $@ ;;
  -h           ) print_help ;;

  help )
    case $1 in
      current ) current -h ;;
      go      ) go_workspace -h ;;
      *       ) print_help ;;
    esac
  ;;

  *         ) echo "$PROGNAME -h" 1>&2 ;;
esac

exit $?
