#!/usr/bin/env bash

currentdir=$(pwd)

declare -a configs=(
    '.zshrc' \
    '.bashrc' \
    '.vimrc' \
    '.bash_profile'
)

declare -a directories=(
    'workspace' \
    'git'
)

# check for the above config files and create symbolic links pointing
# back to this repo's configs
for val in "${configs[@]}"; do
    if [ -f ~/"$val" ]; then
        rm ~/"$val" && ln -s "$currentdir"/"$val" ~/"$val"
    else
        ln -s "$currentdir"/"$val" ~/"$val"
    fi
done

# check for the above directories and create them in the home directory
# if not found
for i in "${directories[@]}"; do
    if [ -d ~/"$i" ]; then
        echo "$i directory found"
    else
        mkdir ~/"$i"
    fi
done
