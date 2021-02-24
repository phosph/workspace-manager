#!/usr/bin/env bash
# shellcheck disable=SC2068
# readonly PROGDIR=$(readlink -m "$(dirname $0)")

create_env() {
  echo "alias workspace_manager='$PROGDIR/workspace.sh'"
  echo '
    workspace-s() {
      if [[ $WORKSPACE_PATH == '' ]]; then
       echo "\$WORKSPACE_PATH is not set"
       return 1
      fi
       case $1 in
         go | -g | create ) eval " `workspace_manager $@ `" ;;
         current)
            case $2 in
              -g | --go ) eval " `workspace_manager $@ `" ;;
              *) workspace_manager $@  ;;
            esac
         ;;
         *) workspace_manager $@  ;;
       esac
    }
  '
#  echo "
#   alias workspace_manager='/home/jesus/Proyectos/workspace/core/workspace-manager/lib/workspace.sh'
#   workspace-s() {
#     if [[ \$WORKSPACE_PATH == '' ]]; then
#      echo \"\\\$WORKSPACE_PATH is not set\"
#      return 1
#     fi
#      case \$1 in
#        go | -g | create ) eval \" \`workspace_manager \$@ \`\" ;;
#        current)
#           case \$2 in
#             -g | --go ) eval \" \`workspace_manager \$@ \`\" ;;
#             *) workspace_manager \$@  ;;
#           esac
#        ;;
#        *) workspace_manager \$@  ;;
#      esac
#   }
# "

}
