#!/bin/bash
########################################################################
# Created By: Ross Derewianko Ping Identity Corporation
# Creation Date: Febuary 2015
# Last modified: Feburary 23, 2015
# Brief Description: Update the JSS (built and tested on ubuntu 12.04.4)
# make sure to chmod this with 555, then invoke with sudo ./scriptname.sh
# you'll still need to manually transfer the jssinstaller.run
# this script requires expect
########################################################################
logLocation="/var/log/"

#looks for expect
if [ -f "/usr/bin/expect" ]; then
	echo "expect found"
	else
	echo "expect not found please run the command:"
	echo "---"
	echo "sudo apt-get install expect"
	echo "---"
	echo "then try this script agian"
	exit 1
fi

#borrowed log file from one of John Kitzmiller's scripts
	# Create log file

	NOW="$(date +"%Y-%m-%d-%H-%M")"
	echo "Creating $logLocation/$NOW.jssinstaller.log"
	touch $logLocation/$NOW.installer.log

	# Redirect stderr to stdout and print all to log

	exec 2>&1 > >(tee $logLocation/$NOW.jssinstaller.log)


##### FUNCTIONS ####

##function ask
function ask() {
	# http://djm.me/ask
	while true; do

		if [ "${2:-}" = "Y" ]; then
			prompt="Y/n"
			default=Y
		elif [ "${2:-}" = "N" ]; then
			prompt="y/N"
			default=N
		else
			prompt="y/n"
			default=
		fi

		# Ask the question
		read -p "$1 [$prompt] " REPLY

		# Default?
		if [ -z "$REPLY" ]; then
			REPLY=$default
		fi

		# Check if the reply is valid
		case "$REPLY" in
			Y*|y*) return 0 ;;
			N*|n*) return 1 ;;
		esac

	done
}

#look for sudo access
function issudo() {
	if ! [ $(id -u) = 0 ]; then
		echo "I am not root! run me agian with sudo!"
		exit 1
	fi
}

#confirms with user they've backed up the db
function dbcheck() {
	if ask "Did you backup the database?[Y]" Y; then
		echo "User has stated the Database is backed up"
	else
		echo "No, database needs to be backed up"
		exit 0
	fi
}

#questions user if they want to run updates
function runupdates() {
	if ask "Do you want to run updates[Y]" Y; then
		echo "I will run updates at the end of install"
		updates="0"
	else
		echo "updates will not be run"
		updates="1"
	fi
}

#Select which install file
function whatfile() {
	prompt="Please select the JSS install file:"
	options=($(find -maxdepth 1 -name \*.run -print0 | xargs -0))

	PS3="$prompt "
	select opt in "${options[@]}" "Quit" ; do
		if (( REPLY == 1 + ${#options[@]} )) ; then
			exit 0

		elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
			echo  "You picked $opt which is file $REPLY"
			break

		else
			echo "Invalid option. Try another one."
		fi
	done
}

#stops tomcat
function stoptomcat() {
	echo "stopping tomcat"
	/etc/init.d/jamf.tomcat7 stop
}

#running install
function updatejss() {
	expect <<- DONE
		set timeout -1
		spawn sh $opt
		# Look for  prompt
		expect "*Proceed?  (y/n):*"
		send "y\n"
		expect "$"
		expect eof
	DONE
}

#updateos
function updateos() {
	if [ $updates -eq 0 ]
	then
	echo "doing updates"
	/usr/bin/apt-get update
	/usr/bin/apt-get upgrade -qq --force-yes
	fi
}


##### end functions ####

##### run script####
issudo
dbcheck
runupdates
whatfile
stoptomcat
updatejss
updateos

#put here to just let the user see a reboot
sleep 10
echo "Rebooting buh bye!"
reboot now