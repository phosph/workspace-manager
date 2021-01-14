#!/usr/bin/env bash
workspace_path=$1
shift

if [ ! -z "$1" ] && [ -d "$workspace_path/$1" ]; then

  ruta="$workspace_path/$1"

  if [ ! -z "$2" ] && [ -d "$ruta/$2" ]; then
    ruta="$ruta/$2"
  else
    ruta="$ruta/core"
  fi

  echo "$ruta"

  exit 0
else
  exit 1
fi
