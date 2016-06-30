#!/bin/bash
########################################################################
# Created By: Ross Derewianko Ping Identity Corporation
# Creation Date: Jun, 2016
# Last modified: Jun 29, 2016
# Brief Description: Serializes VMWare Fusion
# Pieces taken from: https://github.com/franton/VMWare_Fusion/blob/master/Serialise-Fusion.sh

########################################################################
##get SN
if [ "$4" != "" ] && [ "$serial" == "" ]; then
  serial=$4
fi


# Has VMWare Fusion actually been installed?
function checkvmware() {
if [ ! -x /Applications/VMware\ Fusion.app/Contents/Library/Initialize\ VMware\ Fusion.tool ];
then
    echo "Error: VMware Fusion tool is not executable."
	exit 1
	else
	serialize
fi
}

function serialize() {
#Everything hopefully checks out. Run the serialiser.
echo "serial installed"
/Applications/VMware\ Fusion.app/Contents/Library/Initialize\ VMware\ Fusion.tool set "" "" ${serial}
exit 0
}


checkvmware
