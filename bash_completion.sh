#!/usr/bin/bash

create-completion() {
  commandNamed=$1
  if ! command -v $commandNamed &> /dev/null; then
    return
  fi

  echo "complete -o default -F __autocomplection_workspace $commandNamed"
}
