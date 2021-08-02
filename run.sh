#!/usr/bin/env bash

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
    s=($(realpath --relative-to="$WORKSPACE_ROOT" . | sed "s/\// /"))
    if [ "${s[0]}" = '.' ] || [ "${s[0]}" = '..' ]; then
        return 1
    fi
    
    echo "${s[0]} ${s[1]}"
}

workspace() {
    if [[ "$1" == 'ps1' ]]; then
        _workspace_get_currents
    else
        output=$("`_workspace_get_real_path`/main.py" $@)
        if [ $? -eq 3 ]; then
            eval "$output"
        else
            echo "$output"
        fi
    fi
}

[[ "$1" == 'ps1' ]] && workspace $@
