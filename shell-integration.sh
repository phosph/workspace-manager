#!/usr/bin/env bash

_workspace_completions() {
    local cur_word prev_word
    cur_word="${COMP_WORDS[COMP_CWORD]}"
    prev_word="${COMP_WORDS[COMP_CWORD - 1]}"
    local command_name="${COMP_WORDS[0]}"
    local command="${COMP_WORDS[1]}"

    # Try to get WORKSPACE_ROOT from alias
    local alias_def
    alias_def=$(alias "$command_name" 2>/dev/null)
    if [[ -n "$alias_def" ]]; then
        # e.g. alias myws='WORKSPACE_ROOT=/path/to/ws workspace'
        if [[ "$alias_def" =~ WORKSPACE_ROOT=\'([^\']*) ]]; then
            export WORKSPACE_ROOT="${BASH_REMATCH[1]}"
        fi
    fi

    # Lista de comandos principales
    local commands="ps1 new-root go list path create init help"
    if [[ -n "$alias_def" ]]; then
        commands="ps1 go list path create init help"
    fi

    # Si es el primer argumento, autocompletar con los comandos
    if [ "${COMP_CWORD}" -eq 1 ]; then
        COMPREPLY=($(compgen -W "${commands}" -- "${cur_word}"))
        return 0
    fi

    case "${command}" in
        go)
            if [[ "${prev_word}" == "-z" || "${prev_word}" == "--zone" ]]; then
                COMPREPLY=($(compgen -W "core doc" -- "${cur_word}"))
                return 0
            fi
            # Obtener lista de workspaces y añadir opciones
            local workspaces
            workspaces=$(workspace.sh list 2>/dev/null | tail -n +2 | xargs)
            local go_opts="-z --zone"
            COMPREPLY=($(compgen -W "${workspaces} ${go_opts} /" -- "${cur_word}"))
            ;;
        path)
            local workspaces
            workspaces=$(workspace.sh list 2>/dev/null | tail -n +2 | xargs)
            local path_opts="-c --current"
            COMPREPLY=($(compgen -W "${workspaces} ${path_opts}" -- "${cur_word}"))
            ;;
        create)
            if [[ "${COMP_CWORD}" -eq 2 ]]; then
                # No hay sugerencias para el nombre del nuevo workspace
                COMPREPLY=()
            elif [[ "${COMP_CWORD}" -eq 3 ]]; then
                COMPREPLY=($(compgen -W "-f --force" -- "${cur_word}"))
            fi
            ;;
        *)
            # No hay autocompletado para otros comandos
            COMPREPLY=()
            ;;
    esac

    return 0
}

complete -F _workspace_completions workspace.sh
complete -F _workspace_completions workspace
