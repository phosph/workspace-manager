#!/usr/bin/env bash

case $1 in
  -h | --help)
echo \
"
workspace-init usage:
  workspace init NAME [ --repo|-r GIT-REPO [CUSTOM_REPO_NAME] ]

  NAME    será el nombre del workspace

se creará con la siquiente estructura:
  \$NAME
  ├── core
  └── doc

opciones:
  --repo | -r GIT-REPO    se clona el repositiorio GIT-REPO con git y se entrará en el
                          directorio que haya sido creado

nota:
  si se proporciona un GIT-REPO, se irá al path que este genere, una vez dentro, si
  se detecta que es un proyecto no instalable, se correrá 'yarn install' o 'npm install'
  según sea el caso
"

  exit
  ;;
esac

workspace_path=$1
new_work_dir=$2
repo=''
repo_name=''

new_workspace="${workspace_path}/${new_work_dir}"

shift
shift

if [ ! -z "$1" ]; then
  case $1 in
    --repo | -r)
      if [ ! -z "$2" ]; then
        repo=$2
      fi
      if [ ! -z $3 ]; then
        repo_name=$3
      fi
      shift
      shift
    ;;
  esac
fi


mkdir -p "$new_workspace/{core,doc}"

if [ ! -z "$repo" ]; then
  # clone
  cd "$new_workspace/core"
  if [ ! -z "$repo_name" ]; then
    git clone $repo "$repo_name"
  else
    git clone $repo
  fi

  # install if js project
  a=(`ls ./`)
  cd "${a[0]}"
  if [ -f "./package.json" ]; then
    if [ -f "./yarn.lock" ]; then
      yarn install
    elif [ -f "package-lock.json" ]; then
      npm i
    fi
  fi
fi


tree -L 2 $new_workspace
