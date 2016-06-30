#!/bin/bash
########################################################################
# Created By: Ross Derewianko Ping Identity Corporation
# Creation Date: Jun, 2016
# Last modified: Jun 29, 2016
# Brief Description: Airserver serializer for use on the JSS
########################################################################
##get SN
if [ "$4" != "" ] && [ "$serial" == "" ]; then
  serial=$4
fi


# Has AirServer actually been installed?
function checkairserver() {
if [ ! -x /Applications/AirServer.app/Contents/MacOS/AirServerl ];
then
    echo "Error: Airserver is not executable."
	exit 1
	else
	serialize
fi
}

function serialize() {
#Everything hopefully checks out. Run the serialiser.
echo "serial installed"
/Applications/AirServer.app/Contents/MacOS/AirServer --activate "$serial"
exit 0
}


checkairserver
