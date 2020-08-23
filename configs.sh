#!/usr/bin/bash

declare -a ConfigsArray=('.zshrc' '.bashrc' '.vimrc' '.bash_profile')

for val in ${ConfigsArray[@]}; do
    ln -s ~/git/configs/$val ~/$val
done
