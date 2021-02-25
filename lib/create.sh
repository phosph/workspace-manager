#!/usr/bin/env bash

create() {
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

    return 0
    ;;
  esac

  # WORKSPACE_PATH=$1
  local new_work_dir=$1
  local repo=''
  local repo_name=''

  new_workspace="${WORKSPACE_PATH}/${new_work_dir}"

  # shift
  # shift

  if [ ! -z "$2" ]; then
    case $2 in
      --repo | -r)
        if [ ! -z "$3" ]; then
          repo=$3
        fi
        if [ ! -z $4 ]; then
          repo_name=$4
        fi
        ;;
    esac
  fi


  mkdir -p $new_workspace/{core,doc}

  if [ ! -z "$repo" ]; then
    # clone
    cd "$new_workspace/core" || return
    if [ ! -z "$repo_name" ]; then
      git clone $repo "$repo_name"
    else
      git clone $repo
    fi

    # install if js project
    # a=(`ls ./`)
    mapfile -t a < <(ls ./)
    cd "${a[0]}" || return
    if [ -f "./package.json" ]; then
      if [ -f "./yarn.lock" ]; then
        yarn install
      elif [ -f "package-lock.json" ]; then
        npm i
      fi
    fi
  fi


  tree -L 2 $new_workspace
}
