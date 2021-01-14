#!/usr/bin/bash

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

EJEMPLOS
    workspace cd
    workspace cd Tyba
    workspace cd Tyba doc
"
# WORKSPACE_NAME      nombre de algún workspace ya creado
#     sub-path        cualquier sub path dentro \$WORKSPACE_PATH/\$WORKSPACE_NAME/
#                     default es core
  return 0
}


# export -f _workspace_init_help
export -f _workspace_help
