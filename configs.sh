#!/usr/bin/env bash

currentdir=$(pwd)

declare -a configs=('.zshrc' '.bashrc' '.vimrc' '.bash_profile')

for val in ${configs[@]}; do
    if [ -f ~/$val ]; then
        rm ~/$val && ln -s $currentdir/$val ~/$val
    else
        ln -s $currentdir/$val ~/$val
    fi

done
