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

get_real_path() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  echo $DIR
}

readonly PROGNAME=$(basename $0)
readonly PROGDIR="`get_real_path`"

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
  create       ) create $@ ;;
  -l | list    ) list $@ ;;
  -g | go      ) go_workspace $@ ;;
  -p | path    ) path $@ ;;
  -c | current ) current $@ ;;
  -e | exec    ) execute $@ ;;
  init          ) create_env $@ ;;
  -h           ) print_help ;;
  -v           ) echo "0.3-alpah"; return 0 ;;

  help )
    case $1 in
      current ) current -h ;;
      go      ) go_workspace -h ;;
      exec      ) execute -h ;;
      *       ) print_help ;;
    esac
  ;;

  *         ) echo "$PROGNAME -h" 1>&2 ;;
esac

exit $?
