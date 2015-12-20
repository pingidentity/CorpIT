#!/bin/sh
########################################################################
# Created By: Ross Derewianko
# For Ping Identity Corporation 2014
# Creation Date: March 2014
# Last modified: March 27, 2014
# Brief Description: Creates a file that casper can figure out what vpn
########################################################################

#Statically Define VPN if needed

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO “vpn”
if [ "$4" != "" ] && [ "$VPN" == "" ]; then
	VPN=$4
fi

plist='locationtoyourplist'
########################################################################
# Script
########################################################################

#check to see if the file exists
		if [ -f $plist ]; then

		#Change modify the plist to name the vpn the user is requests!
			defaults write $plist "VPN" $VPN
							
		#if the file doexn't exist write to it, and say the file was just deployed"
		else
			defaults write $plist "VPN" $VPN
			defaults write $plist "JustDeployed" "yes"	
		fi
exit 0