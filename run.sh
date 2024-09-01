#!/usr/bin/env bash

set -e

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
            return 1;
        fi
    else
        WORKSPACE_ROOT="$(__workspace_folder_worspace)"

        if [[ ! $WORKSPACE_ROOT ]]; then
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

    s=($(realpath --relative-to="$WORKSPACE_ROOT" . | sed "s/\// /"))

    source <(
        source "$WORKSPACE_ROOT/.workspace";
        echo "WORKSPACE_NAME=$WORKSPACE_NAME"
    )

    if [ "${s[0]}" = '.' ]; then
        echo "$WORKSPACE_NAME"
        return 0
    fi

    z=($(echo "${s[1]}" | sed "s/\// /"))

    echo "$WORKSPACE_NAME ${s[0]} ${z[0]} ${z[1]}"
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

    new-root
    \t create a new workspace root

    go <WORKSPACE> [-z|--zone <ZONE>]
        <ZONE> = core|doc

    \t go to WORKSPACE, if <ZONE> is not provided, core is used.

    list
    \t list all workspaces at WORKSPACE_ROOT

    path <WORKSPACE>
    path -c|--current
    \t prints the workspace path. If --current is provided instead, the current workdpsace will be printed if any
"
}

PROGRAM_NAME="$0"

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

        [[ "$WORKSPACE_PATH" == "" ]] && return 1;
        # WORKSPACE_NAME="$(basename "$WORKSPACE_PATH")"
    else
        # WORKSPACE_NAME="$1"
        WORKSPACE_PATH="$WORKSPACE_ROOT/$1"
    fi

    if [[ ! -d "$WORKSPACE_PATH" || ! -e "$WORKSPACE_PATH/.wrkspace" ]]; then
        return 1;
    fi

    echo "$WORKSPACE_PATH"
}


workspace-go() {
    _validate_workspace_root;

    local WORKSPACE_PATH

    WORKSPACE_PATH="$(workspace-path "$@")"
    shift;

    local ZONE="core"

    if [[ "$1" =~ ^-z|(-zone)$ ]]; then
        [[ -z "$2" ]] && return 1;

        ZONE="$2"
    fi

    if [[ ! -d "$WORKSPACE_PATH/$ZONE" ]]; then
        echo "zone '$ZONE' does not exist";
        return 1;
    else
        WORKSPACE_PATH="$WORKSPACE_PATH/$ZONE"
    fi

    echo "$WORKSPACE_PATH"
    return 3
}

workspace-init() {
    # shellcheck disable=SC2016
    echo '
workspace() {
    output="$(workspace_manager "$@")"
    declare -i return_value="$?"
    if [ $return_value -eq 3 ]; then
        eval "$output"
    else
        echo "$output"
        return $return_value;
    fi
}
'
}

workspace() {

    OPTION="$1";
    shift;

    case $OPTION in
        init) workspace-init;;
        -h|--help) workspace_help;;
        ps1) workspace_ps1;;
        new-root) workspace-root-creator "$@";;
        go) workspace-go "$@";;
        list) workspace-list "$@";;
        path) workspace-path "$@";;
    esac

    # if [[ "$1" == 'ps1' ]]; then
    #     _workspace_get_currents
    # elif [[ "$1" == 'new-root' ]]; then
    #     "$(_workspace_get_real_path)/workspace-root-createor.sh"
    # else
    #     output=$("$(_workspace_get_real_path)/main.py" "$@")
    #     if [ $? -eq 3 ]; then
    #         eval "$output"
    #     else
    #         echo "$output"
    #     fi
    # fi
}

# [[ "$1" == 'ps1' ]] &&
workspace "$@"
