#!/bin/bash

# BASH STUFF
export PS1="\[\e[35m\]\h \[\e[36m\]\u \[\e[37m\]\w $ "

# macOS STUFF

# open music duh
alias music="open -a Music"

# update home brew
alias brewUpdate="brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew doctor"

# Show/Hide Invisible files
alias showInvisibles="defaults write com.apple.finder AppleShowAllFiles YES"
alias hideInvisibles="defaults write com.apple.finder AppleShowAllFiles NO"

# softwareupdate
alias softwareUpdate="sudo softwareupdate -ir --restart"

# remove catalina bash warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# ALIASES THO

# check the weather
alias weather="curl wttr.in/80033"

# FUNCTIONS THO

# get the length of a string
lenstr () {
    echo -n $1 | wc -c
}

# use rosetta 2 to brew install something
ibrew () {
    arch -x86_64 brew install $1
}
