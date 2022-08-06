#!/bin/zsh

# ZSH STUFF
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# git auto complete
autoload -Uz compinit && compinit

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%b)'

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# dedicated history file
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY # extra history info
setopt INC_APPEND_HISTORY # adds commands to the HISTFILE as they're typed
setopt appendhistory # history accessible between sessions

# prompt shows hostname, user name, directory, git branch if a git repo
PS1='%F{yellow}%m%f %F{green}%n%f %~${vcs_info_msg_0_} (╯’□’)╯︵ ' # hostname is yellow, user name is green

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

# ALIASES THO

# check the weather
alias weather="curl wttr.in/80033"

# FUNCTIONS THO

# get the length of a string
function lenstr {
    echo -n $1 | wc -c
}

# open a man page in preview dot app
function manpage {
    man -t $1 | open -fa Preview
}

# create an xkcd-style password, make sure to follow with a number so it knows how long to 
# make the password
function mkpass {
    curl https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt 2>/dev/null \
    | cut -f 2 \
    | sort -R \
    | head -n $1 \
    | xargs echo \
    | sed 's/ /-/g'
}

# get the ip address the internet thinks you have
function myip {
    curl http://ipecho.net/plain ; echo
}

# list the subdirectories of a directory and then git pull on those paths, you must provide
# the top level directory, added some sed logic to remove any secondary forward slashes that might
# come through
function gitPull {
    ls $1 | xargs -I{} echo $1/{} | sed 's/\/\//\//' | xargs -I{} git -C {} pull
}

# show the oneline/decorated version of a git log. make sure to 
# include a number so that it knows how many lines to display.
function gitLog {
    git log --oneline --decorate -$1
}

# ENV VARIABLES THO
export GREP_OPTIONS='--color=auto'