#!/usr/bin/env bash

set -e

PROGRAM_NAME="$(basename "$0")"

__workspace_folder_worspace() {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/.workspace" ]]; do
    path=${path%/*}
  done
  echo "$path"
}


# _workspace_get_real_path() {
#   SOURCE="${BASH_SOURCE[0]}"
#   while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
#     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#     SOURCE="$(readlink "$SOURCE")"
#     [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#   done
#   DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
#   echo $DIR
# }


_validate_workspace_root() {

    # local WORKSPACE_ROOT=
    if [[ $WORKSPACE_ROOT ]]; then
        if [[ ! -e "$WORKSPACE_ROOT/.workspace"  ]]; then
            echo "workspace invalid" >&2
            return 1;
        fi
    else
        WORKSPACE_ROOT="$(__workspace_folder_worspace)"

        if [[ ! $WORKSPACE_ROOT ]]; then
            echo "workspace root not found" >&2
            return 1;
        fi
    fi


    source "$WORKSPACE_ROOT/.workspace";
}

workspace_ps1() {
    local -r WORKSPACE_ROOT="$(__workspace_folder_worspace)"
    if [[ ! $WORKSPACE_ROOT ]]; then
        return 1;
    fi

    # shellcheck disable=SC1090
    source <(
        # shellcheck disable=SC1091
        source "$WORKSPACE_ROOT/.workspace";
        echo "WORKSPACE_NAME='$WORKSPACE_NAME'"
    )

    local -r current_path="$(realpath --relative-to="$WORKSPACE_ROOT" .)"

    if [ "${current_path}" = '.' ]; then
        echo "$WORKSPACE_NAME"
        return 0
    fi

    local -r WORSPACE_PROJECT_PATH="$(echo "$current_path" | cut -d "/" -f1)"

    # WORSPACE_PROJECT_NAME=

    if [[ -f "$WORKSPACE_ROOT/$WORSPACE_PROJECT_PATH/.wrkspace" ]]; then
        # shellcheck disable=SC1090
        source <(
            # shellcheck disable=SC1091
            source "$WORKSPACE_ROOT/$WORSPACE_PROJECT_PATH/.wrkspace"
            echo "WORSPACE_PROJECT_NAME=$WORKSPACE"
        );
    else
        WORSPACE_PROJECT_NAME="$WORSPACE_PROJECT_PATH"
    fi

    local -r ZONE="$(echo "$current_path" | cut -d "/" -f2)"
    local SUBPATH
    SUBPATH="$(realpath --relative-to="$WORKSPACE_ROOT/$WORSPACE_PROJECT_PATH/${ZONE}" .)"

    [[ "$SUBPATH" == '.' ]] && SUBPATH="";

    echo "$WORKSPACE_NAME;${WORSPACE_PROJECT_NAME};${ZONE};${SUBPATH}"
}

workspace_help() {
    echo -e "${PROGRAM_NAME}

Usage:
    ${PROGRAM_NAME} -h|--help
    ${PROGRAM_NAME} new-root
    ${PROGRAM_NAME} go workspace

Options:
    -h, --help \t\t print help

Commands:
    ps1
    \t prints workspace data in the current format:  WORSPACE_ROOT WORKSPACE ZONE SUBPATH

    \t if WORKSPACE_PWD_DISABLE is set, this command return 1

    new-root
    \t create a new workspace root

    go <WORKSPACE> [-z|--zone <ZONE>]
        <ZONE> = core|doc

    \t go to WORKSPACE, if <ZONE> is not provided, core is used.
    \t if WORKSPACE is \"/\", is considered as the workspace root

    list
    \t list all workspaces at WORKSPACE_ROOT

    path <WORKSPACE>
    path -c|--current
    \t prints the workspace path. If --current is provided instead, the current workdpsace will be printed if any

    create <WORKSPACE> [-f|--force]
    \t create a new worspace
"
}


workspace-root-creator() {
    echo "Workspace root creator"
    read -p "enter the new Workspace Name: " rootName
    read -p "enter the Workspace command name: " commandName

    local WORKSPACE_ROOT="$HOME/$rootName"

    read -p "Workspace root $rootName will be created at $WORKSPACE_ROOT with the $commandName command [Y/n]" -n 1 -s aggrement
    echo ""

    if [[ ! "$aggrement" ]]; then aggrement="Y"; fi

    if [ "${aggrement,,}" = "n" ]; then
        echo "aborted"
        exit 1
    fi


    echo "alias $commandName=\"WORKSPACE_ROOT='$WORKSPACE_ROOT' workspace\"" >> "$HOME/.bash_aliases"

    mkdir -p "$WORKSPACE_ROOT"

    echo "WORKSPACE_NAME=$commandName" > "$WORKSPACE_ROOT/.workspace"

    echo "done."
    echo "please open a new terminal to get acces to the $commandName command"
}

workspace-list() {
    _validate_workspace_root;

    echo -e "Workspaces in $WORKSPACE_NAME:"

    for fichero in "$WORKSPACE_ROOT"/*; do
        if [[ -d $fichero && -e "$fichero/.wrkspace" ]]; then
            echo -e "\t$(basename "$fichero")"
        fi
    done
}

workspace-path() {
    _validate_workspace_root;

    local WORKSPACE_PATH
    # local WORKSPACE_NAME

    if [[ "$1" =~ ^-c|(-current)$ ]]; then
        WORKSPACE_PATH=$(pwd)
        while [[ -n "$WORKSPACE_PATH" && "$WORKSPACE_PATH" =~ ^"${WORKSPACE_ROOT}" && ! -e "$WORKSPACE_PATH/.wrkspace" ]]; do
            WORKSPACE_PATH="${WORKSPACE_PATH%/*}"
        done

        [[ "$WORKSPACE_PATH" == "" ]] && {
            echo "workspace not found" >&2
            return 1;
        }
        # WORKSPACE_NAME="$(basename "$WORKSPACE_PATH")"
    else
        # WORKSPACE_NAME="$1"
        WORKSPACE_PATH="$WORKSPACE_ROOT/$1"
    fi

    if [[ ! -d "$WORKSPACE_PATH" || ! -e "$WORKSPACE_PATH/.wrkspace" ]]; then
        echo "Invalid workspace" >&2
        return 1;
    fi

    echo "$WORKSPACE_PATH"
}


workspace-go() {

    local WORKSPACE_PATH

    if [[ "$1" == "/" ]]; then
        _validate_workspace_root;
        WORKSPACE_PATH="$WORKSPACE_ROOT"
    else
        WORKSPACE_PATH="$(workspace-path "$@")"
        shift;

        local ZONE="core"

        if [[ "$1" =~ ^-z|(-zone)$ ]]; then
            [[ -z "$2" ]] && {
                echo "Invalid zone" >&2
                return 1;
            }

            ZONE="$2"
        fi

        if [[ ! -d "$WORKSPACE_PATH/$ZONE" ]]; then
            echo "zone '$ZONE' does not exist" >&2;
            return 1;
        else
            WORKSPACE_PATH="$WORKSPACE_PATH/$ZONE"
        fi
    fi

    echo "$WORKSPACE_PATH"
    return 3
}

workspace-init() {
    # shellcheck disable=SC2016
    echo '
workspace() {
    output="$(workspace.sh "$@")"
    declare -i return_value="$?"
    if [ $return_value -eq 3 ]; then
        cd "$output"
    else
        echo "$output"
        return $return_value;
    fi
}
'
}

workspace-create() {
    _validate_workspace_root;

    local WORKSPACE_NAME="$1"

    local WORKSPACE_PATH

    WORKSPACE_PATH="$WORKSPACE_ROOT/${WORKSPACE_NAME}"

    if [[ -e $WORKSPACE_PATH ]] && ! [[ "$2" =~ ^-f|(-force)$ ]]; then
        echo "Workspace $WORKSPACE_NAME already exist" >&2
        exit 1;
    fi

    mkdir -p "${WORKSPACE_PATH}"/{core,doc};

    cd "${WORKSPACE_PATH}"

    echo "WORKSPACE=\"${WORKSPACE_NAME}\""> .wrkspace

    cd ./core;

    pwd

    exit 3;
}

workspace() {

    OPTION="$1";
    shift;

    case $OPTION in
        init) workspace-init;;
        -h|--help) workspace_help;;
        ps1)
            # disable
            [[ -v WORKSPACE_PWD_DISABLE ]] && return 1;
            workspace_ps1;;
        new-root) workspace-root-creator "$@";;
        go) workspace-go "$@";;
        list) workspace-list "$@";;
        path) workspace-path "$@";;
        create) workspace-create "$@";;
        *)
            echo -e "invalid command\n"
            workspace_help;
            exit 1
        ;;
    esac
}

workspace "$@"
