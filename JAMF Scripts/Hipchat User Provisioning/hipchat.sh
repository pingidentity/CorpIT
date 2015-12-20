#!/bin/sh
########################################################################
# Created By: Ross Derewianko Ping Identity Corporation
# Creation Date: September, 2014 
# Last modified: September 06, 2014
# Brief Description: Auto Provision Hipchat via self service
########################################################################

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 3 AND, IF SO, ASSIGN TO "UserName"
if [ "$3" != "" ] && [ "$username" == "" ]; then
	username=$3
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "hipChatToken"
if [ "$4" != "" ] && [ "$hipChatToken" == "" ]; then
	hipChatToken=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "apiuser"
if [ "$5" != "" ] && [ "$apiuser" == "" ]; then
	apiuser=$5
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "apipass"
if [ "$6" != "" ] && [ "$apipass" == "" ]; then
	apipass=$6
fi

#check for cocoa dialogue & if not install it
if [ -d "/usr/sbin/cocoaDialog.app" ]; then
	CD="/usr/sbin/cocoaDialog.app/Contents/MacOS/CocoaDialog"
else
	echo "CocoaDialog.app not found installing" 
	/usr/sbin/jamf policy -trigger cocoa
fi

########################################################################
# Script
########################################################################

#find out the url of the JSS!
jss=`defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url`
echo "jss is $jss"
#call jss for info regarding the user that's run the script
response=$(curl "$jss"JSSResource/users/name/"$username" --user "$apiuser:$apipass")
#cleans up the name and adds a + between the white space so curl doesnt see it as a carriage return
full_name=$(echo $response | /usr/bin/awk -F'<full_name>|</full_name>' '{print $2}'| sed 's/ /+/g')
#cleans up the email and changes @ to %40
email=$(echo $response | /usr/bin/awk -F'<email>|</email>' '{print $2}'| sed 's/@/%40/g')
#cleans up the job title or as hicphat calls "position" and adds a + between the white space so curl doesnt see it as a carriage return
position=$(echo $response | /usr/bin/awk -F'<position>|</position>' '{print $2}'| sed 's/ /+/g')
#gets a list of all users in hipchat 
hipchatuserlist=`curl -sS https://api.hipchat.com/v1/users/list?auth_token="$hipChatToken"`
#looks for user
hipchatuserexists=$(echo $hipchatuserlist | grep $username)

if [ "$hipchatuserexists" = "" ]; then
	echo "no user found"
	#ask for password two times
	hipchatpass1=`"$CD" secure-standard-inputbox --title "Hipchat Password" --informative-text "Please enter a password for Hipchat to Use. It must be more than 5 characters"`
		if [ "$hipchatpass1" == "2" ]; then
			echo "user cancelled"
			exit 1
	    	fi
	hipchatpass2=`"$CD" secure-standard-inputbox --title "Hipchat Password" --informative-text "Please re-enter a password for Hipchat to Use. It must be more than 5 characters"`
		if [ "$hipchatpass2" == "2" ]; then
			echo "user cancelled"
			exit 1
		fi


	while [ 1 ]
	do 
	#check to see if the passwords asked for match and loop until they do
	if [ "$hipchatpass1" == "$hipchatpass2" ]; then
	break
	else 
	#passwords wrong!
		#echo "passwords don't match! reprompt"
	hipchatpass1=`"$CD" secure-standard-inputbox --title "Hipchat Password" --informative-text "You had a mix up! Please enter a password for Hipchat to Use. It must be more than 5 characters"`
			if [ "$hipchatpass1" == "2" ]; then
				echo "user cancelled"
				exit 1
			fi
	hipchatpass2=`"$CD" secure-standard-inputbox --title "Hipchat Password" --informative-text "Please re-enter a password for Hipchat to Use. It must be more than 5 characters"`
			if [ "$hipchatpass2" == "2" ]; then
				echo "user cancelled"
				exit 1
			fi	
		fi
	sleep 1
	done
	
	#push info to hicphat

	hipchatresponse=`curl -d "email="$email"&name="$full_name"&title="$position"&password="$hcp"" https://api.hipchat.com/v1/users/create?auth_token="$hipChatToken"`
	info=`"$CD" bubble  --timeout "5" --title "All done!" --text "Please login to hipchat, your username is: $username@pingidentity.com" --icon-file /Library/Application\ Support/JAMF/EndUserSupport/PI_SQLogo.icns`

	exit 0
else
	echo "$username exists"
	exit 0
fi