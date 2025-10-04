#!/usr/bin/env bash

currentdir=$(pwd)

if ! command -v brew &> /dev/null; then
    echo "Homebrew not installed, install at https://brew.sh"
    exit 1
fi

if [[ ! -f "$currentdir/Brewfile" ]]; then
    echo "Brewfile not found"
    exit 1
fi

if ! brew bundle --file="$currentdir/Brewfile"; then
    echo "Failed to install some packages, see brew bundle output for more info."
    echo "Continuing..."
else
    echo "Installed all packages."
fi