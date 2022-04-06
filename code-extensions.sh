#!/bin/zsh

# need to follow the directions at 
# https://code.visualstudio.com/docs/setup/mac#_launching-from-the-command-line first


declare -a extensions=(
    'ms-azuretools.vscode-docker' \
    'hashicorp.terraform' \
    'ms-python.vscode-pylance' \
    'ms-python.python' \
    'mechatroner.rainbow-csv' \
    'formulahendry.terminal' \
    'bmalehorn.shell-syntax'
    )

for val in ${extensions[@]}; do
    code --install-extension $val
done