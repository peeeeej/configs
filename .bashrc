#!/usr/bin/env bash

### BASH STUFF ###

# prompt layout and colors; host name, user name, directory, git branch if a git branch
export PS1="\[\e[33m\]\h \[\e[32m\]\u \[\e[37m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $"

# history length (infinite!)
HISTSIZE=-1

# file size has no limit
HISTFILESIZE=-1

# ignore commands
HISTIGNORE="history*"

# append to the history file when the shell exits instead of overwriting
shopt -s histappend

# after each command, append to the history and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'n'}history -a; history -c; history -r"

### macOS STUFF ###

# open music duh
alias music="open -a Music"

# update home brew
alias brewUpdate="brew update ; brew upgrade ; brew upgrade --cask ; brew cleanup ; brew doctor"

# softwareupdate
alias softwareUpdate="sudo softwareupdate -ir --restart"

### ALIASES THO ###

# check the weather
alias weather="curl wttr.in/80033"
alias za="python3 ~/git/pizza-calculator/pizza.py"

### FUNCTIONS THO ###

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
    ipv4=$(curl -s ipv4.icanhazip.com)
    ipv6=$(curl -s ipv6.icanhazip.com)
    echo "IPv4: $ipv4"
    echo "IPv6: $ipv6"
}

# list the subdirectories of a directory and then git pull on those paths, you must provide
# the top level directory, added some sed logic to remove any secondary forward slashes that might
# come through
gitPull () {
    ls $1 | xargs -I{} echo $1/{} | sed 's/\/\//\//' | xargs -I{} git -C {} pull
}

# same as gitPull above but status instead of pull
gitStatus () {
    ls $1 | xargs -I{} echo $1/{} | sed 's/\/\//\//' | xargs -I{} git -C {} status
}

# show the oneline/decorated version of a git log. make sure to 
# include a number so that it knows how many lines to display.
gitLog () {
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' -$1
}

# just type desktopCleanup
desktopCleanup () {
    today=$(date "+%Y-%m-%d")
    me=$(whoami)
    backup_dir="/Users/$me/Documents/desktop_backup_$today"

    mkdir -p $backup_dir ; mv ~/Desktop/* $backup_dir
}

# just type workspaceCleanup
workspaceCleanup () {
    today=$(date "+%Y-%m-%d")
    me=$(whoami)
    backup_dir="/Users/$me/Documents/workspace_backup_$today"

    mkdir -p $backup_dir && mv ~/workspace/* $backup_dir
}

# get some helpful info about the system
report () {
    active_shell=$(echo $SHELL)
    echo "Shell: $active_shell"
    sw_vers
}

randomPup () {
    pup_response=$(curl -s -X GET https://dog.ceo/api/breeds/image/random)
    pup_link=$(echo $pup_response | jq -r '.message')
    open -u $pup_link
}
### ENV VARIABLES THO ###

# highlight grep search terms in results
export GREP_OPTIONS='--color=auto'

# remove catalina bash warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# for discogs client stuff
export DISCOGS_TOKEN="$(security find-generic-password  -gs DISCOGS_TOKEN -w)"
