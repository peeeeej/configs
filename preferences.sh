#!/usr/bin/env bash

# Set up logging
LOG_FILE="$HOME/setup_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check for macOS version compatibility
MACOS_VERSION=$(sw_vers -productVersion)
if [[ "$MACOS_VERSION" < "11.0" ]]; then
    log_message "This script is compatible with macOS 11.0 and later."
    exit 1
fi

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until we have finished
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

############
### DOCK ###
############

# Automatically hide and show the dock
if ! defaults -currentHost write com.apple.dock autohide -bool true; then
    log_message "Failed to set dock autohide."
fi

# Don't show recent applications in dock
if ! defaults -currentHost write com.apple.dock show-recents -bool false; then
    log_message "Failed to disable recent applications in dock."
fi

LOGGED_USER=$(whoami)
sudo su "$LOGGED_USER" -c 'defaults delete com.apple.dock persistent-apps' 

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
Voice_Memos=$(dock_item /System/Applications/Voice\ Memos.app)

# making an enormous number of assumptions here. check to see if music apps have been set up by 
# looking for the arturia software app. there's typically no way that's been installed without also
# installing ableton and/or logic. failing that, look to see if the apps script has been run by 
# checking for iTerm; if it's there, configure the dock for third party apps, else bring up a 
# bare-bones set of macOS native apps

if [[ -d "$music_test_app" ]]; then
        sudo su "$LOGGED_USER" -c "defaults write com.apple.dock persistent-apps -array '$Google_Chrome' '$Messages' '$Slack' '$zoom_us' '$Music' '$BespokeSynth' '$Arturia_Software_Center' '$Ableton_Live_11_Suite' '$Logic_Pro' '$Voice_Memos' '$iTerm' '$Visual_Studio_Code' '$Photos' '$Reminders' '$Notes' '$App_Store' '$System_Settings'"
    elif [[ -d "$directory_test_app" ]]; then
        sudo su "$LOGGED_USER" -c "defaults write com.apple.dock persistent-apps -array '$Google_Chrome' '$Messages' '$Slack' '$zoom_us' '$Music' '$Voice_Memos' '$iTerm' '$Visual_Studio_Code' '$Photos' '$Reminders' '$Notes' '$App_Store' '$System_Settings'"
    else
        echo "Consider running the apps script to install third party apps!"
        sudo su "$LOGGED_USER" -c "defaults write com.apple.dock persistent-apps -array '$Safari' '$Messages' '$Music' '$Voice_Memos' '$Photos' '$Reminders' '$Notes' '$Terminal' '$App_Store' '$System_Settings'"
fi

killall Dock

####################
### /ETC CHANGES ###
####################

# Add Homebrew paths to /etc/paths
if [[ -f /opt/homebrew/bin/brew ]]; then
    log_message "Homebrew detected"
    if ! sudo sed -i '' -E '1s|^|/opt/homebrew/bin\n|' /etc/paths; then
        log_message "Failed to add Homebrew bin to /etc/paths."
    fi
    if ! sudo sed -i '' -E '$a\
/opt/homebrew/sbin' /etc/paths; then
        log_message "Failed to add Homebrew sbin to /etc/paths."
    fi
    if ! sudo sed -i '' -E 's/[ \t]+$//' /etc/paths; then
        log_message "Failed to clean up trailing whitespace in /etc/paths."
    fi
    if ! sudo sed -i '' -E '/^$/d' /etc/paths; then
        log_message "Failed to remove empty lines from /etc/paths."
    fi
    log_message "Added Homebrew paths"
else
    log_message "Homebrew not installed, visit https://brew.sh"
fi

# Add GNU Bash to /etc/shells
if [[ -f /opt/homebrew/bin/bash ]]; then
    log_message "GNU Bash detected"
    if ! sudo sed -i '' -E '$a\
/opt/homebrew/bin/bash' /etc/shells; then
        log_message "Failed to add GNU Bash to /etc/shells."
    fi
    if ! sudo sed -i '' -E 's/[ \t]+$//' /etc/shells; then
        log_message "Failed to clean up trailing whitespace in /etc/shells."
    fi
    if ! sudo sed -i '' -E '/^$/d' /etc/shells; then
        log_message "Failed to remove empty lines from /etc/shells."
    fi
    log_message "Added GNU Bash to /etc/shells"
else
    log_message "GNU Bash not installed, make sure to <brew install bash>"
fi

##############
### FINDER ###
##############

# Show icons for external hard drives and removable media on the desktop
if ! defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true; then
    log_message "Failed to show external hard drives on desktop."
fi
if ! defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false; then
    log_message "Failed to hide hard drives on desktop."
fi
if ! defaults write com.apple.finder ShowMountedServersOnDesktop -bool false; then
    log_message "Failed to hide mounted servers on desktop."
fi
if ! defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true; then
    log_message "Failed to show removable media on desktop."
fi

################
### TRACKPAD ###
################

# Enable tap to click
if ! defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true; then
    log_message "Failed to enable tap to click."
fi

# Enforce two-finger right click
if ! defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true; then
    log_message "Failed to enforce two-finger right click."
fi

# Enable three finger dragging
if ! defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true; then
    log_message "Failed to enable three-finger dragging."
fi

# Enforce natural scrolling
if ! defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true; then
    log_message "Failed to enforce natural scrolling."
fi

# Deactivate force click and haptic feedback
if ! defaults write "Apple Global Domain" com.apple.trackpad.forceClick -bool false; then
    log_message "Failed to deactivate force click and haptic feedback."
fi
if ! defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false; then
    log_message "Failed to deactivate detents."
fi
if ! defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true; then
    log_message "Failed to suppress force on trackpad."
fi

###############
### MENUBAR ###
###############

# Show volume in menu bar always
if ! defaults -currentHost write com.apple.controlcenter Sound -int 18; then
    log_message "Failed to show volume in menu bar."
fi

# Show Bluetooth in menu bar
if ! defaults -currentHost write com.apple.controlcenter Bluetooth -int 2; then
    log_message "Failed to show Bluetooth in menu bar."
fi

# Show clock
if ! defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Clock.menu"; then
    log_message "Failed to add clock to menu bar."
fi

# Set clock date/time format
if ! defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm:ss a"; then
    log_message "Failed to set clock date/time format."
fi

# Show seconds
if ! defaults write com.apple.menuextra.clock ShowSeconds -bool true; then
    log_message "Failed to show the seconds in the menu bar clock."
fi

# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
if ! sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName; then
    log_message "Failed to set AdminHostInfo."
fi

###################
### MISC SYSTEM ###
###################

# Enable the automatic update check
if ! defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true; then
    log_message "Failed to enable automatic update check."
fi

# Check for software updates daily, not just once per week
if ! defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1; then
    log_message "Failed to set software update frequency."
fi

# Disable hibernation
if ! sudo pmset -a hibernatemode 0; then
    log_message "Failed to disable hibernation."
fi

###############
### THE END ###
###############

# Wait a sec so the user can determine if they need to install anything
sleep 20

# Kill affected applications and log out
if ! osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'; then
    log_message "Failed to log out."
fi

log_message "Script completed."
