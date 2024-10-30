#!/usr/bin/env bash

# Check for macOS version compatibility
MACOS_VERSION=$(sw_vers -productVersion)
if [[ "$MACOS_VERSION" < "11.0" ]]; then
    echo "This script is compatible with macOS 11.0 and later."
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
defaults -currentHost write com.apple.dock autohide -bool true

# Don't show recent applications in dock
defaults -currentHost write com.apple.dock show-recents -bool false

LOGGED_USER=$(whoami)
sudo defaults delete com.apple.dock persistent-apps

# Define test application paths
directory_test_app='/Applications/iTerm.app'
music_test_app='/Applications/Arturia/Arturia Software Center.app'

dock_item() {
    printf '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>%s</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>' "$1"
}

# Apps List
apps_list=(
    "/System/Applications/Safari.app"
    "/System/Applications/Messages.app"
    "/System/Applications/Music.app"
    "/System/Applications/Photos.app"
    "/System/Applications/Reminders.app"
    "/System/Applications/Notes.app"
    "/System/Applications/App Store.app"
    "/System/Applications/System Settings.app"
    "/System/Applications/Utilities/Terminal.app"
    "/Applications/Google Chrome.app"
    "/Applications/Slack.app"
    "/Applications/zoom.us.app"
    "/Applications/iTerm.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/BespokeSynth.app"
    "/Applications/Arturia/Arturia Software Center.app"
    "/Applications/Ableton Live 11 Suite.app"
    "/Applications/Logic Pro X.app"
    "/System/Applications/Voice Memos.app"
)

# Create dock items
dock_items=()
for app in "${apps_list[@]}"; do
    if [[ -d "$app" ]]; then
        dock_items+=("$(dock_item "$app")")
    fi
done

# Configure the dock based on installed applications
if [[ -d "$music_test_app" ]]; then
    sudo defaults write com.apple.dock persistent-apps -array "${dock_items[@]}"
elif [[ -d "$directory_test_app" ]]; then
    # Exclude music and Arturia apps if iTerm is found
    sudo defaults write com.apple.dock persistent-apps -array "$(dock_item '/Applications/Google Chrome.app')" "$(dock_item '/System/Applications/Messages.app')" "$(dock_item '/Applications/Slack.app')" "$(dock_item '/Applications/zoom.us.app')" "$(dock_item '/System/Applications/Voice Memos.app')" "$(dock_item '/Applications/iTerm.app')" "$(dock_item '/Applications/Visual Studio Code.app')" "$(dock_item '/System/Applications/Photos.app')" "$(dock_item '/System/Applications/Reminders.app')" "$(dock_item '/System/Applications/Notes.app')" "$(dock_item '/System/Applications/App Store.app')" "$(dock_item '/System/Applications/System Settings.app')"
else
    echo "Consider running the apps script to install third party apps!"
    sudo defaults write com.apple.dock persistent-apps -array "$(dock_item '/System/Applications/Safari.app')" "$(dock_item '/System/Applications/Messages.app')" "$(dock_item '/System/Applications/Music.app')" "$(dock_item '/System/Applications/Voice Memos.app')" "$(dock_item '/System/Applications/Photos.app')" "$(dock_item '/System/Applications/Reminders.app')" "$(dock_item '/System/Applications/Notes.app')" "$(dock_item '/System/Applications/Utilities/Terminal.app')" "$(dock_item '/System/Applications/App Store.app')" "$(dock_item '/System/Applications/System Settings.app')"
fi

killall Dock

####################
### /ETC CHANGES ###
####################

# Add Homebrew paths to /etc/paths
if [[ -f /opt/homebrew/bin/brew ]]; then
    echo "Homebrew detected"
    sudo sed -i '' -E '1s|^|/opt/homebrew/bin\n|' /etc/paths
    sudo sed -i '' -E '$a\
/opt/homebrew/sbin' /etc/paths
    sudo sed -i '' -E 's/[ \t]+$//' /etc/paths
    sudo sed -i '' -E '/^$/d' /etc/paths
    echo "Added Homebrew paths"
else
    echo "Homebrew not installed, visit https://brew.sh"
fi

# Add GNU Bash to /etc/shells
if [[ -f /opt/homebrew/bin/bash ]]; then
    echo "GNU Bash detected"
    sudo sed -i '' -E '$a\
/opt/homebrew/bin/bash' /etc/shells
    sudo sed -i '' -E 's/[ \t]+$//' /etc/shells
    sudo sed -i '' -E '/^$/d' /etc/shells
    echo "Added GNU Bash to /etc/shells"
else
    echo "GNU Bash not installed, make sure to <brew install bash>"
fi

##############
### FINDER ###
##############

# Show icons for external hard drives and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

################
### TRACKPAD ###
################

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Enforce two-finger right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true

# Enable three finger dragging
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Enforce natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Deactivate force click and haptic feedback
defaults write "Apple Global Domain" com.apple.trackpad.forceClick -bool false
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -bool false
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool true

###############
### MENUBAR ###
###############

# Show volume in menu bar always
defaults -currentHost write com.apple.controlcenter Sound -int 18

# Show Bluetooth in menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 2

# Show clock
defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Set clock date/time format
defaults write com.apple.menuextra.clock DateFormat "EEE MMM d  h:mm:ss a"

# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

###################
### MISC SYSTEM ###
###################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable hibernation
sudo pmset -a hibernatemode 0

###############
### THE END ###
###############

# Wait a sec so the user can determine if they need to install anything
sleep 20

# Kill affected applications and log out
osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'
