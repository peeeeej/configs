#!/bin/zsh

# ZSH STUFF

# dedicated history file
HISTFILE=~/.zsh_history
HISTSIZE=3000
SAVEHIST=3000
setopt EXTENDED_HISTORY # extra history info
setopt INC_APPEND_HISTORY # adds commands to the HISTFILE as they're typed
setopt appendhistory # history accessible between sessions

# prompt shows hostname, user name, directory
PS1='%F{yellow}%m%f %F{green}%n%f %~ %# ' # hostname is yellow, user name is green

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

# ALIASES THO

# check the weather
alias weather="curl wttr.in/80033"

# FUNCTIONS THO

# get the length of a string
function lenstr {
    echo -n $1 | wc -c
}

# use rosetta 2 to brew install something
function ibrew {
    arch -x86_64 brew install $1
}
