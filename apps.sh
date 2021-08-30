#!/bin/bash

# make this mess in the downloads directory
cd ~/Downloads/

# troubleshooting
pwd

# google chrome
curl -O -J -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# visual studio code
curl -O -J -L  https://go.microsoft.com/fwlink/?linkid=620882

# iterm2
curl -L https://iterm2.com/downloads/stable/latest --output iTerm2.zip

# slack
curl -L https://slack.com/ssb/download-osx --output Slack.dmg

# zoom
curl -O -L https://zoom.us/client/latest/ZoomInstaller.pkg

# rectangle
curl -O -L https://github.com/rxhanson/Rectangle/releases/download/v0.48/Rectangle0.48.dmg