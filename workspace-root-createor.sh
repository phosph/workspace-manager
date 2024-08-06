#!/usr/bin/env bash
set -e

echo "Workspace root creator"
read -p "enter the new Workspace Name: " rootName
read -p "enter the Workspace command name: " commandName

WORKSPACE_ROOT="$HOME/$rootName"

read -p "Workspace root $rootName will be created at $WORKSPACE_ROOT with the $commandName command [Y/n]" -n 1 -s aggrement
echo ""

if [[ ! "$aggrement" ]]; then aggrement="Y"; fi

if [ "${aggrement,,}" = "n" ]; then
    echo "aborted"
    exit 1
fi


echo "alias $commandName=\"WORKSPACE_ROOT='$WORKSPACE_ROOT' workspace\"" >> "$HOME/.bash_aliases"

mkdir -p $WORKSPACE_ROOT

echo "WORKSPACE_NAME=$commandName" > "$WORKSPACE_ROOT/.workspace"

echo "done."
echo "please open a new terminal to get acces to the $commandName command"