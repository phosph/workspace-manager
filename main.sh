#!/usr/bin/bash

if [ -z "$WORKSPACE_PATH" ]
then
    export WORKSPACE_PATH="$HOME/Work"
fi


_workspace_init() {

    case $1 in
        --help) echo \
"workspace-init usage:
    workspace init NAME [ --repo|-r GIT-REPO ]

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

    cd $WORKSPACE_PATH;

    new_workspace="$1"
    shift;

    mkdir -p $new_workspace/{core,doc}
    tree $new_workspace
    cd "$new_workspace/core"

    if [ ! -z "$1" ]
    then
        case $1 in
            --repo | -r)
                if [ ! -z "$2" ]
                then
                    git clone $2
                    a=(`ls ./`)
                    cd "${a[0]}"
                    if [ -f "./package.json" ]
                    then
                        if [ -f "./yarn.lock" ]
                        then
                            yarn install
                        elif [ -f "package-lock.json" ]
                        then
                            npm i
                        fi
                    fi
                    shift
                    shift
                fi
            ;;
        esac
    fi
}

_workspace_cd() {
    if [ ! -z "$1" ] && [ -d "$WORKSPACE_PATH/$1" ]
    then
        ruta="$WORKSPACE_PATH/$1"

        if [ ! -z "$2" ] && [ -d "$ruta/$2" ]
        then
            ruta="$ruta/$2"
        else
            ruta="$ruta/core"
        fi
        cd $ruta
    else
        cd "$WORKSPACE_PATH"
    fi
}

_workspace_help() {
    echo \
"workspace usage

    workspace COMMAND ...
    workspace [-h|--help]


commands:
    init                  inicializa un nuev0 workspace
    cd [WORKSPACE_PATH]   cambia el directorio actual por el del workspace
    go                    alias de cd
    help COMMAND

opciones
    --help | -h         imprime este mensaje

se puede utilizar la variable de entorno \$WORKSPACE_PATH para establecer dónde se crearán
los proyectos (workspaces). default WORKSPACE_PATH=\"\$HOME/Work\"

ALIAS
    wks   -> workspace
    wkscd -> workspace cd

EJEMPLOS
    workspace cd
    workspace cd Tyba
    workspace cd Tyba doc
"
# WORKSPACE_NAME      nombre de algún workspace ya creado
#     sub-path        cualquier sub path dentro \$WORKSPACE_PATH/\$WORKSPACE_NAME/
#                     default es core
}

workspace() {

    case $1 in
        init | i)
            shift
            _workspace_init $@
            ;;

        cd|go)
            shift
            _workspace_cd $@
            ;;

        help)
            if case "$2" in (init) true ;; (*) false; esac; then
                _workspace_init --help
            else
                _workspace_help
            fi
            ;;
        --help | -h | *) _workspace_help ;;
    esac

}

export -f workspace
