####Self Service VPN's

Created By: Ross Derewianko  
For Ping Identity Corporation 2014  
Creation Date: March 2014  
Last modified: March 27, 2014  

--------------------------------------------------------
Self Service VPN's
--------------------------------------------------------

#####Installation.


1. Install the Ea's making sure to edit the plist to a file location you'd prefer. This needs to be edited in all four files
2. Create a policy with that runs the script "selfserviceinstallvpn.sh" with the value in 4 of the vpn name
3. Create Smart groups scoped out to the vpnName
4. Create Config Profile of vpn, and scope it to the smart group created in step 3.

--------------------------------------------------------

The files used in this are listed in the order they would run:   
selfserviceinstallvpn.sh (builds the config file)  
EA - checkforvpn.sh (reads what vpn it is)  
EA - checkfornewlydeployedvpn.sh   
Justdeployed.sh (if new deployment)  


--------------------------------------------------------	

#####Extension Attributes
EA -checkforvpn.sh  
 Searches/checks for the plist and the values in VPN  
EA - checkfornewlydeployedvpn.sh   
 Searches/checks for the plist and the values in JustDeployed = Yes or No  


--------------------------------------------------------	

#####Policies
VPN - vpnDemo  
Uses the script selfservicevpn.sh passing through ```<vpn name>``` in perameter value 4 and updates inventory.  
Uses selfservicevpn.sh scoped to ongoing as the u ser may have to install the vpn on a loaner machine.  
Vpn Was Newly Deployed - Deploy Dock Icon  
Puts the VPN icon on the users top bar. Uses justdeployed.sh scoped to login  
Remove All Vpns  
Pops a value of vpnremoved into the VPN value. Casper removes vpn config.  

--------------------------------------------------------	
#####Scripts  

selfserviceinstallvpn.sh  
This script is the main script for the vpn deployment. What it does, is read from the policy parameter 4, which is the vpn group name.  

With vpnDemo, it writes it to the file located at ```<plist location>```  under the child value of VPN  
```
<key>VPN</key>
	<string>vpnDemo</string>
```
It also writes if the vpn was just deployed this is based on if the file exists previously. If the file exists the vpn was not newly deployed to a new machine. And the below is written.  
```
<key>JustDeployed</key>
	<string>no</string> 
```

If the file didn’t exist from the check above it writes the following  
```
<key>JustDeployed</key>
	<string>yes</string> 
```	
--------------------------------------------------------	
#####Smart Groups  

Each VPN has a Smart group called VPNDEPLOY - vpnName
The smart group is based on whats reported in the EA EA - checkforvpn.sh based on the reported ea, casper auto places that computer in said group.  

--------------------------------------------------------	
#####Configuration Profiles  

Each VPN has its own config profile, which is what casper pushes to the client through a secure connection via Apples push network.  

Each Config Profile contains the following  
Vpn name  
vpn server  
vpn group name  
vpn shared secret  
the username has a value of $USERNAME  


Each configuration profile is scoped to the smart group of VPNDEPLOY - vpnDemo which corresponds with the vpn group name above.  

--------------------------------------------------------	
#####User Flow  

User Flow for vpnDemo  
Assumptions to base this will work off of:  
User is in the Security group in AD of vpn - vpnDemo  
Casper is connected to AD to read this value  
The users machine in location information has the users Directory Account Listed.  



1. User logs into casper  
2. User Clicks on My VPN’s and casper shows vpnDemo  
3. User clicks install. Casper does the following.  
	a. Casper Runs selfserviceinstall.sh and passes the value vpnDemo  
	b. Casper does an inventory after script is run  
	c. Casper places user in smart group VPNDEPLOY - vpnDemo  
	d. Casper auto pushes vpn (this could take upto 15 mins to happen)  

