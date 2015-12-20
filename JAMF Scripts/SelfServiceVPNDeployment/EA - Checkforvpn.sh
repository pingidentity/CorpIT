#!/bin/sh
########################################################################
# Created By: Ross Derewianko
# For Ping Identity Corporation 2014
# Creation Date: March 2014
# Last modified: March 27, 2014
# Brief Description: Find out what VPN is listed in the config file.
########################################################################
plist='locationtoyourplist'
########################################################################
# Script
########################################################################

if [ -f $plist ]; then

#read that file, and find out whats in  it.
	result=`defaults read "$plist" VPN`
#if that result is blank then
	if [ -z "$result" ]; then
	echo "<result>NO VPN Currently</result>"
	else 
#if its not blank print the result	
	echo "<result>$result</result>"
	fi

else
#but if the file doesn't exist print no no vpn currently
	echo "<result>NO VPN Currently</result>"

fi
exit 0



