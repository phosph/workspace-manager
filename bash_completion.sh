#!/usr/bin/bash

__autocomplection_wks() {
  if [ -z "$WORKSPACE_PATH" ]; then
    WORKSPACE_PATH="$HOME/Work"
  fi

  command_named=$1
  current_word_called=$2
  word_before_called=$3

  if [ "${#COMP_WORDS[@]}" = "2" ]; then

    COMPREPLY=($(compgen -W "init i cd go help --help -h" "${current_word_called}"))

  elif [ "${#COMP_WORDS[@]}" = "3" ]; then

    case $word_before_called in
      cd | go ) COMPREPLY=($(compgen -W "`ls $WORKSPACE_PATH 2> /dev/null`" "${current_word_called}")) ;;
      help    ) COMPREPLY=($(compgen -W "init i cd go" "${current_word_called}")) ;;
    esac

  elif [ "${#COMP_WORDS[@]}" = "4" ]; then

    case "${COMP_WORDS[1]}" in
      cd | go ) COMPREPLY=($(compgen -W "`ls "$WORKSPACE_PATH/$word_before_called" 2> /dev/null`" "${current_word_called}")) ;;
    esac

  fi

  return 0
}

complete -F __autocomplection_wks workspace
