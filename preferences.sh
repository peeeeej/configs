#!/usr/bin/env bash

# ask for the administrator password upfront
sudo -v

# keep-alive: update existing `sudo` time stamp until we have finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

############
### DOCK ###
############

# automatically hide and show the dock
defaults -currentHost write com.apple.dock autohide -bool true

# don't show recent applications in dock
defaults -currentHost write com.apple.dock show-recents -bool false

LOGGED_USER=$(whoami) 
sudo su $LOGGED_USER -c 'defaults delete com.apple.dock persistent-apps' 

directory_test_app='/Applications/iTerm.app'

music_test_app='/Applications/Arturia/Arturia Software Center.app'

dock_item() { 
 
    printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>', "$1" 
 
} 

# Apps List
Safari=$(dock_item /System/Cryptexes/App/System/Applications/Safari.app) 
Messages=$(dock_item /System/Applications/Messages.app) 
Music=$(dock_item /System/Applications/Music.app)
Photos=$(dock_item /System/Applications/Photos.app)
Reminders=$(dock_item /System/Applications/Reminders.app)
Notes=$(dock_item /System/Applications/Notes.app)
App_Store=$(dock_item /System/Applications/App\ Store.app)
System_Settings=$(dock_item /System/Applications/System\ Settings.app)
Terminal=$(dock_item /System/Applications/Utilities/Terminal.app)
Google_Chrome=$(dock_item /Applications/Google\ Chrome.app)
Slack=$(dock_item /Applications/Slack.app)
zoom_us=$(dock_item /Applications/zoom.us.app)
iTerm=$(dock_item /Applications/iTerm.app)
Visual_Studio_Code=$(dock_item /Applications/Visual\ Studio\ Code.app)
BespokeSynth=$(dock_item /Applications/BespokeSynth.app)
Arturia_Software_Center=$(dock_item /Applications/Arturia/Arturia\ Software\ Center.app)
Ableton_Live_11_Suite=$(dock_item /Applications/Ableton\ Live\ 11\ Suite.app)
Logic_Pro=$(dock_item /Applications/Logic\ Pro\ X.app)

# making an enormous number of assumptions here. check to see if music apps have been set up by 
# looking for the arturia software app. there's typically no way that's been installed without also
# installing ableton and/or logic. failing that, look to see if the apps script has been run by 
# checking for iTerm; if it's there, configure the dock for third party apps, else bring up a 
# bare-bones set of macOS native apps

if [[ -d "$music_test_app" ]]; then
        sudo su $LOGGED_USER -c "defaults write com.apple.dock persistent-apps -array '$Google_Chrome' '$Messages' '$Slack' '$zoom_us' '$Music' '$BespokeSynth' '$Arturia_Software_Center' '$Ableton_Live_11_Suite' '$Logic_Pro' '$iTerm' '$Visual_Studio_Code' '$Photos' '$Reminders' '$Notes' '$App_Store' '$System_Settings'"
    elif [[ -d "$directory_test_app" ]]; then
        sudo su $LOGGED_USER -c "defaults write com.apple.dock persistent-apps -array '$Google_Chrome' '$Messages' '$Slack' '$zoom_us' '$Music' '$iTerm' '$Visual_Studio_Code' '$Photos' '$Reminders' '$Notes' '$App_Store' '$System_Settings'"
    else
        echo "Consider running the apps script to install third party apps!"
        sudo su $LOGGED_USER -c "defaults write com.apple.dock persistent-apps -array '$Safari' '$Messages' '$Music' '$Photos' '$Reminders' '$Notes' '$Terminal' '$App_Store' '$System_Settings'"
fi

killall Dock

####################
### /ETC CHANGES ###
####################

# add homebrew paths to /etc/paths
# check for homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
    # visual confirmation
    echo "homebrew detected"
    # add /opt/homebrew/bin to the first line of /etc/paths
    sudo sed -i '' -E '1s/^/\/opt\/homebrew\/bin\n/' /etc/paths
    # add /opt/homebrew/sbin to the last line of /etc/paths, line break is a POSIX convention
    sudo sed -i '' -E '$a\
    \'$'\n/opt/homebrew/sbin' /etc/paths
    # remove trailing blank space that i can't explain
    sudo sed -i '' -E 's/[ '$'\t'']+$//' /etc/paths
    # remove a new blank line that i also can't explain
    sudo sed -i '' -E '/^$/d' /etc/paths
    # we're done
    echo "added homebrew paths"
else
    # didn't find homebrew, install it at https://brew.sh
    echo "homebrew not installed, visit https://brew.sh"
fi

# add GNU bash to /etc/shells
if [[ -f /opt/homebrew/bin/bash ]]; then
    echo "GNU bash detected"
    sudo sed -i '' -E '$a\
    \'$'\n\/opt/homebrew/bin/bash' /etc/shells
    sudo sed -i '' -E 's/[ '$'\t'']+$//' /etc/shells
    sudo sed -i '' -E '/^$/d' /etc/shells
    sudo sed -i '' -E '/\# one of these shells\.$/a\
    \'$'\n' /etc/shells
    echo "added GNU bash to /etc/shells"
else
    echo "GNU bash not installed, make sure to <brew install bash>"
fi

##############
### FINDER ###
##############

# show icons for external hard drives and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

################
### TRACKPAD ###
################

# enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# enforce two-finger right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# enable three finger dragging
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# enfore natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# deactivate force click and haptic feedback
defaults write "Apple Global Domain" com.apple.trackpad.forceClick -bool False
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool False
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool True

###############
### MENUBAR ###
###############

# show volume in menu bar always
defaults -currentHost write com.apple.controlcenter Sound -int 18

# show bluetooth in menu bar
defaults -currentHost write com.apple.controlecenter Bluetooth -int 2

# show clock
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Clock.menu"

# set clock date/time format
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm:ss a"

# reveal ip address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

###################
### MISC SYSTEM ###
###################

# enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# disable hibernation
sudo pmset -a hibernatemode 0

###############
### THE END ###
###############

# wait a sec so the user can determine if they need to install anything
sleep 20

# kill affected applications and log out
osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'
