#!/bin/bash

# BASH STUFF
export PS1="\[\e[35m\]\h \[\e[36m\]\u \[\e[37m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] (╯’□’)╯︵ "

# macOS STUFF

# open music duh
alias music="open -a Music"

# update home brew
alias brewUpdate="brew update && brew upgrade && brew upgrade --cask && brew cleanup && brew doctor"

# Show/Hide Invisible files
alias showInvisibles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hideInvisibles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

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

# get git branch info for displaying on the terminal prompt
parse_git_branch () {
 git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# open a man page in preview dot app
manpage () {
    man -t $1 | open -fa Preview
}

# create an xkcd-style password, make sure to follow with a number so it knows how long to 
# make the password
mkpass () {
    curl https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt 2>/dev/null \
    | cut -f 2 \
    | sort -R \
    | head -n $1 \
    | xargs echo \
    | sed 's/ /-/g'
}

# get the ip address the internet thinks you have
myip () {
    curl http://ipecho.net/plain ; echo
}

# list the subdirectories of a directory and then git pull on those paths, you must provide
# the top level directory, added some sed logic to remove any secondary forward slashes that might
# come through
gitPull () {
    ls $1 | xargs -I{} echo $1/{} | sed 's/\/\//\//' | xargs -I{} git -C {} pull
}

# show the oneline/decorated version of a git log. make sure to 
# include a number so that it knows how many lines to display.
gitLog () {
    git log --oneline --decorate -$1
}
# ENV VARIABLES THO
export GREP_OPTIONS='--color=auto'