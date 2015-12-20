#!/bin/sh
########################################################################
# Created By: Ross Derewianko
# For Ping Identity Corporation 2014
# Creation Date: March 2014
# Last modified: March 27, 2014
# Brief Description: Checks to see if vpn is newly deployed
########################################################################
plist='locationtoyourplist'
########################################################################
# Script
########################################################################


#check to see if the file exists
if [ -f $plist ]; then

#read that file, and find out whats in  it.
	result=`defaults read "$plist" JustDeployed`
		
#if that result is blank then
	if [ "$result" = "yes" ]; then
	echo "<result>Yes</result>"
	else 
#if its not blank print the result	
	echo "<result>No</result>"
	fi

else
#but if the file doesn't exist print no no vpn currently
	echo "<result>File Not Found</result>"

fi
exit 0

