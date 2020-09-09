#!/usr/bin/bash

_workspace_init_help() {
  echo \
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


export -f _workspace_init_help
export -f _workspace_help
