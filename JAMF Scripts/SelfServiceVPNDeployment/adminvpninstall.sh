#!/bin/sh
########################################################################
# Created By: Ross Derewianko
# For Ping Identity Corporation 2014
# Creation Date: April 2014
# Last modified: July 7, 2014
# Brief Description: Overrides policies for admins to install ANY VPN
########################################################################

plist='locationtoyourplist'

if [ -d "/usr/sbin/cocoaDialog.app" ]; then
CD="/usr/sbin/cocoaDialog.app/Contents/MacOS/CocoaDialog"
#you may have a different location for cocoa
else
echo "CocoaDialog.app not found installing"
 /usr/sbin/jamf policy -trigger cocoa
fi
########################################################################
# Script
########################################################################
#ask for tthe vpn admin would deploy
WhichVPN=`"$CD" dropdown --title "VPN Configuration" --text "Please select the users VPN" --items "VPN1" "VPN2" Vpn3 "Vpn4" --string-output --height 130 --button1 "Configure"`

#Clean up the multi line variable.. and make her one!
VPN=`echo "$WhichVPN" | sed -n 2p`

#check to see if the file exists
		if [ -f $plist ]; then

		#Change modify the vpn.ping to name the vpn the user is requesting in the file!
			defaults write $plist "VPN" $VPN
							
		#if the file doexn't exist write to it, and say the file was just deployed"
		else
			defaults write $plist "VPN" $VPN
			defaults write $plist "JustDeployed" "yes"	
		fi


exit 0
