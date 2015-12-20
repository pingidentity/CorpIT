#!/bin/sh
########################################################################
# Created By: Ross Derewianko
# For Ping Identity Corporation 2014
# Creation Date: March 2014
# Last modified: March 27, 2014
# Brief Description: Kills finder top bar to display the icon
########################################################################
plist='locationtoyourplist'
########################################################################
# Script
########################################################################


/usr/libexec/plistBuddy add ~/Library/Preferences/ByHost/com.apple.systemuiserver.plist /System/Library/CoreServices/Menu Extras/VPN.menu
killall SystemUIServer -HUP  
defaults write $plist "JustDeployed" "no"	
exit 0