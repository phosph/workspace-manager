#!/usr/bin/env bash

__workspace_folder_worspace () {
  path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/.workspace" ]]; do
    path=${path%/*}
  done
  echo "$path"
}


_workspace_get_real_path() {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  echo $DIR
}

_workspace_get_currents() {
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

workspace() {
    if [[ "$1" == 'ps1' ]]; then
        _workspace_get_currents
    elif [[ "$1" == 'new-root' ]]; then
        $(_workspace_get_real_path)/workspace-root-createor.sh
    else
        output=$("$(_workspace_get_real_path)/main.py" $@)
        if [ $? -eq 3 ]; then
            eval "$output"
        else
            echo "$output"
        fi
    fi
}

[[ "$1" == 'ps1' ]] && workspace $@
