print_help() {
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
}
