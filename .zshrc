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

# backup the ~/Music Directory since it's the only personal stuff on board
alias backup="rsync -uva ~/Music /Volumes/wonderheart\ music\ backup/"

# update home brew
alias brewUpdate="brew update && brew upgrade && brew cask upgrade && brew cleanup && brew doctor"

# Show/Hide Invisible files
alias showInvisibles="defaults write com.apple.finder AppleShowAllFiles YES"
alias hideInvisibles="defaults write com.apple.finder AppleShowAllFiles NO"

# softwareupdate
alias softwareUpdate="sudo softwareupdate -ir --restart"

# HOME

# check the weather
alias weather="curl wttr.in/Denver"

# WORK WORK

# points to gam for google administration
alias gam='/Users/phurley/bin/gamadv-xtd3/gam'

# update gam
# alias gamUpdate='bash <(curl -s -S -L https://git.io/install-gam) -l'
