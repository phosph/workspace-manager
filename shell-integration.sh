#!/usr/bin/env bash

_idk() {
    # echo "$1"
    # echo "$2"
    # echo "$3"
    # local IFS=$' \t\n'    # normalize IFS
    # local generic=true

    local OPTIONS="--create -g --go -z --zone -c --current -h --help"
    local previous_word
    local current_word
    current_word="${COMP_WORDS[COMP_CWORD]}"
    previous_word="${COMP_WORDS[COMP_CWORD - 1]}"

    # if [[ $generic == true ]]; then
        # # compgen prints paths one per line; could also use while loop
        # IFS=$' '
        

        # shellcheck disable=SC2207
    case "${previous_word}" in
        --create) COMPREPLY=($(compgen -E -- "$current_word"));;
        -g|--go) COMPREPLY=("");;
        -*) COMPREPLY=($(compgen -W "$OPTIONS" -- "$current_word")) ;;
    esac
        # IFS=$' \t\n'
        # fi
    return 0
} >./idk.log

complete -F _idk workspace