#!/bin/bash

# ask for the administrator password upfront
sudo -v

# keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# make this mess in the downloads directory
cd ~/Downloads/

############
### CURL ###
############

# google chrome
curl -O -J -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# visual studio code
curl -O -J -L  https://go.microsoft.com/fwlink/?linkid=620882

# atom
curl -L https://atom.io/download/mac --output atom-mac.zip

# iterm2
curl -L https://iterm2.com/downloads/stable/latest --output iTerm2.zip

# slack
curl -L https://slack.com/ssb/download-osx --output Slack.dmg

# zoom
curl -O -L https://zoom.us/client/latest/ZoomInstaller.pkg

# rectangle
curl -O -L https://github.com/rxhanson/Rectangle/releases/download/v0.48/Rectangle0.48.dmg

##################
### .ZIP FILES ###
##################

declare -a zips=('VSCode-darwin.zip' 'atom-mac.zip' 'iTerm2.zip')

declare -a zip_apps=('Visual Studio Code.app' 'Atom.app' 'iTerm.app')

# unzip .zip files
for val in ${zips[@]}; do
    unzip $val
done

# move apps to applications folder
for val in "${zip_apps[@]}"; do
    mv "$val" /Applications
done

# remove zip files from ~/Downloads
for val in "${zips[@]}"; do
    rm "$val"
done

##################
### .DMG FILES ###
##################

declare -a dmgs=('googlechrome.dmg' 'Slack.dmg' 'Rectangle0.48.dmg')

declare -a volumes=('Google Chrome' 'Slack' 'Rectangle0.48')

# mount .dmg files
for val in ${dmgs[@]}; do
    hdiutil attach $val
done

# copy apps to applications folder
cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications
cp -R /Volumes/Slack/Slack.app /Applications
cp -R /Volumes/Rectangle0.48/Rectangle.app /Applications

# eject .dmg files
for val in "${volumes[@]}"; do
    hdiutil detach /Volumes/"$val"
done

# remove .dmg files
for val in ${dmgs[@]}; do
    rm $val
done

##################
### .PKG FILES ###
##################

sudo installer -pkg ZoomInstaller.pkg -target /