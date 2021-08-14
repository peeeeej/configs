#!/bin/bash

# ask for the administrator password upfront
sudo -v

# keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


### DOCK ###

# automatically hide and show the dock
defaults -currentHost write com.apple.dock autohide -bool true

# don't show recent applications in dock
defaults write com.apple.dock show-recents -bool false

### FINDER ###

# Show icons for external hard drives and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

### TRACKPAD ###

# enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# enforce two-finger right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# enable three finger dragging
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# enfore natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

### MENUBAR ###

# show volume in menu bar
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Volume.menu"

# show bluetooth in menu bar
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

# show clock
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Clock.menu"

# set clock date/time format
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm:ss a"

# reveal ip address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

### MISC SYSTEM ###

# disable system-wide resume
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# disable safe sleep/hibernation
sudo pmset -a hibernatemode 0

# kill affected applications
osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'
