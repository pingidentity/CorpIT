#!/bin/bash

########################################################################
# Originally Created Created By: Andrina Kelly
# Modifications from scripts from Bryson Tyrrell 
# Final by Ross Derewianko
# Creation Date: April 2015
# Last modified: Feb 16,2016
# Brief Description: Gather diagnostic logs and submit to the JSS
########################################################################
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "basic_auth"
if [ "$4" != "" ] && [ "$basic_auth" == "" ]; then
  basic_auth=$4
fi

jss=`defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url`
serial=`/usr/sbin/system_profiler SPHardwareDataType | awk '/Serial Number/ {print $NF}'`

#find the machines ID
fullmachineinfo=$(curl "$jss"JSSResource/computers/serialnumber/"$serial" -H "Authorization: Basic $basic_auth")
machineid=$(echo $fullmachineinfo | /usr/bin/awk -F'<id>|</id>' '{print $2}'| sed 's/ /+/g')

echo $machineid

expect <<- DONE
  set timeout -1
  spawn sysdiagnose
  # Look for  prompt
  expect "*?ontinue*"
  # send blank line (\r) to make sure we get back to gui
  send -- "\r"
  expect eof
DONE
FILE=$(ls -ltr /var/tmp | tail -1 | awk '{print $9}' | grep "sysdiagnose")


fileupload=$(curl -X "POST" "$jss"JSSResource/fileuploads/computers/id/$machineid -F "file=@/var/tmp/$FILE"\
  -H "Authorization: Basic $basic_auth")

exit 0
