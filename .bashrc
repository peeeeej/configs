#!/bin/bash

# BASH STUFF
export PS1="\h \u \w $ "

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

# remove catalina bash warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# HOME

# check the weather
alias weather="curl wttr.in/Denver"

# WORK WORK

# points to gam for google administration
alias gam='/Users/phurley/bin/gamadv-xtd3/gam'

# update gam
# alias gamUpdate='bash <(curl -s -S -L https://git.io/install-gam) -l'
