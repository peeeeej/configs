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

if [[ $(arch) != 'arm64' ]]; then
        # google chrome intel
        curl -O -J -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg
        # slack intel
        curl -L https://slack.com/ssb/download-osx --output Slack.dmg
        # zoom intel
        curl -O -L https://zoom.us/client/latest/ZoomInstaller.pkg
    else
        # google chrome apple silicon
        curl -O -J -L https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg
        # slack apple silicon
        curl -L https://slack.com/ssb/download-osx-silicon --output Slack.dmg
        # zoom apple silicon
        curl -L https://zoom.us/client/latest/Zoom.pkg?archType=arm64 --output ZoomInstaller.pkg
    fi

# visual studio code universal
curl -O -J -L  https://go.microsoft.com/fwlink/?linkid=2156837

# iterm2
curl -L https://iterm2.com/downloads/stable/latest --output iTerm2.zip

# rectangle
curl -O -L https://github.com/rxhanson/Rectangle/releases/download/v0.61/Rectangle0.61.dmg

# 1password
curl -L  https://app-updates.agilebits.com/download/OPM7 --output 1Password.pkg

##################
### .ZIP FILES ###
##################

declare -a zips=('VSCode-darwin-universal.zip' 'iTerm2.zip')

declare -a zip_apps=('Visual Studio Code.app' 'iTerm.app')

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

declare -a dmgs=('googlechrome.dmg' 'Slack.dmg' 'Rectangle0.61.dmg')

declare -a volumes=('Google Chrome' 'Slack' 'Rectangle0.61')

# mount .dmg files
for val in ${dmgs[@]}; do
    hdiutil attach $val
done

# copy apps to applications folder
cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications
cp -R /Volumes/Slack/Slack.app /Applications
cp -R /Volumes/Rectangle0.61/Rectangle.app /Applications

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

declare -a pkgs=('1Password.pkg' 'ZoomInstaller.pkg')

# install pkgs
for val in "${pkgs[@]}"; do
    sudo installer -pkg "$val" -target /
done

# remove zoom and 1Password
rm ZoomInstaller.pkg 1Password.pkg