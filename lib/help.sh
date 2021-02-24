#!/usr/bin/env bash

print_help() {
cat <<EOF
"uso $PROGNAME [-i | init] [-g | go ] [-l | list] [-p | path ] [-c | current]
               [-h | --help] [-e | execute]

commands:
    create [...args]            crea un nuevo workspace
    -g | go <WORKSPACE_NAME>    cambia el directorio actual por el del workspace
    -l | list                   lista los proyecto en WORKSPACE_PATH
    -p | path <WORKSPACE_NAME>  imprime la ruta del workspace
    -c | current [...args]      actúa sobre el workspace actual
    -h | --help                 imprime este mensaje
    env
    -e | execute <command>      (WIP)
    help <COMMAND>


variables de entorno:
   \$WORKSPACE_PATH=<ABSOLUTE_PATH>  establece dónde están los proyectos (workspaces).

EJEMPLOS
    $PROGNAME go
    $PROGNAME go Tyba
    $PROGNAME go Tyba doc
EOF
}
