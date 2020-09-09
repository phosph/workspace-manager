#!/usr/bin/bash

#
# _autocomplection_wks() {
#     # echo $COMP_WORDS
#     if [ -z "$WORKSPACE_PATH" ]
#     then
#         WORKSPACE_PATH="$HOME/Work"
#     fi
#     if [ "${#COMP_WORDS[@]}" = "2" ]; then
#         COMPREPLY=($(compgen -W "init i cd go help --help -h" "${COMP_WORDS[1]}"))
#     elif [ "${#COMP_WORDS[@]}" = "3" ]; then
#         if [ "${COMP_WORDS[1]}" = 'help' ]; then
#             COMPREPLY=($(compgen -W "init go cd" "${COMP_WORDS[2]}"))
#         else
#             COMPREPLY=($(compgen -W "$(ls $WORKSPACE_PATH)" "${COMP_WORDS[2]}"))
#         fi
#     elif [ "${#COMP_WORDS[@]}" = "4" ]; then
#         COMPREPLY=($(compgen -W "$(ls "$WORKSPACE_PATH/${COMP_WORDS[2]}")" "${COMP_WORDS[3]}"))
#     fi
# }
#
#
# _autocomplection_wkscd() {
#     # echo $COMP_WORDS
#     if [ -z "$WORKSPACE_PATH" ]
#     then
#         WORKSPACE_PATH="$HOME/Work"
#     fi
#     if [ "${#COMP_WORDS[@]}" = "2" ]; then
#         if [ "${COMP_WORDS[1]}" = 'help' ]; then
#             COMPREPLY=($(compgen -W "init go cd" "${COMP_WORDS[1]}"))
#         else
#             COMPREPLY=($(compgen -W "$(ls $WORKSPACE_PATH)" "${COMP_WORDS[1]}"))
#         fi
#     elif [ "${#COMP_WORDS[@]}" = "2" ]; then
#         COMPREPLY=($(compgen -W "$(ls "$WORKSPACE_PATH/${COMP_WORDS[1]}")" "${COMP_WORDS[2]}"))
#     fi
# }
#
#
#
#
# alias wks="source `cd "$(dirname "${BASH_SOURCE[0]}")" && pwd`/main.sh"
# complete -F _autocomplection_wks ws
#
# alias wkscd="source `cd "$(dirname "${BASH_SOURCE[0]}")" && pwd`/main.sh go"
# complete -F _autocomplection_wkscd wkscd
