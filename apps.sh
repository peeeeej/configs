#!/usr/bin/env bash

# do you even need to run this?

if [[ $(/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --version 2>/dev/null) ]]; then
    echo "Are you sure you need to run this?"
    exit
fi
# ask for the administrator password upfront
sudo -v

# keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# make this mess in the downloads directory
cd ~/Downloads/ || exit

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
        # visual studio code universal
        curl -J -L  https://go.microsoft.com/fwlink/?linkid=2156837 --output VSCode.zip
    else
        # google chrome apple silicon
        curl -O -J -L https://dl.google.com/chrome/mac/universal/stable/CHFA/googlechrome.dmg
        # slack apple silicon
        curl -L https://slack.com/ssb/download-osx-silicon --output Slack.dmg
        # zoom apple silicon
        curl -L https://zoom.us/client/latest/Zoom.pkg?archType=arm64 --output ZoomInstaller.pkg
        # visual studio code apple silicon
        curl -J -L https://update.code.visualstudio.com/latest/darwin-arm64/stable --output VSCode.zip
    fi

# iterm2
curl -L https://iterm2.com/downloads/stable/latest --output iTerm2.zip

# rectangle
curl -O -L https://github.com/rxhanson/Rectangle/releases/download/v0.88/Rectangle0.88.dmg

##################
### .ZIP FILES ###
##################

declare -a zips=('VSCode.zip' 'iTerm2.zip')

declare -a zip_apps=('Visual Studio Code.app' 'iTerm.app')

# unzip .zip files
for zip in "${zips[@]}"; do
    unzip "$zip"
done

# move apps to applications folder
for app in "${zip_apps[@]}"; do
    mv "$app" /Applications
done

# remove zip files from ~/Downloads
for zip in "${zips[@]}"; do
    rm "$zip"
done

##################
### .DMG FILES ###
##################

declare -a dmgs=('googlechrome.dmg' 'Slack.dmg' 'Rectangle0.88.dmg')

declare -a volumes=('Google Chrome' 'Slack' 'Rectangle0.88')

# mount .dmg files
for dmg in "${dmgs[@]}"; do
    hdiutil attach "$dmg"
done

# copy apps to applications folder
cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications
cp -R /Volumes/Slack/Slack.app /Applications
cp -R /Volumes/Rectangle0.88/Rectangle.app /Applications

# eject .dmg files
for volume in "${volumes[@]}"; do
    hdiutil detach /Volumes/"$volume"
done

# remove .dmg files
for dmg in "${dmgs[@]}"; do
    rm "$dmg"
done

##################
### .PKG FILES ###
##################

declare -a pkgs=('ZoomInstaller.pkg')

# install pkgs
for pkg in "${pkgs[@]}"; do
    sudo installer -pkg "$pkg" -target /
done

# remove zoom and 1Password
for pkg in "${pkgs[@]}"; do
    rm "$pkg"
done