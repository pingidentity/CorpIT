####Machine Diagnostic Logs Upload
Modified By: Ross Derewianko   
For Ping Identity Corporation 2015  
Creation Date: April, 2015   
Last modified: April, 18 2015   
Modified from: Andrina Kelly   
with sniplets from work by: Bryson Tyrrell   

--------------------------------------------------------
Machine Diagnostic Logs Upload
--------------------------------------------------------
#####Config Notes.

To make this work you'll need to update your my.cnf on your Master JSS to allow a higher file size:   
Look for this line:   
max_allowed_packet      = 16M <-- Change this to 30M  

To create the API simple auth key base encode a username and password, you can use an online base64 encoder like:   
https://www.base64encode.org/  
EG: admin:password becomes **YWRtaW46cGFzc3dvcmQ=**  
Run as a script in a policy.


--------------------------------------------------------	
#####Usage.

When the end user runs this, it'll upload that file into the machine's profile under attachments It's important to note, you don't really want to keep all these files on your JSS as it does get stored into the jss'es database. Remove them after you've downloaded it or have remove it at a reasonable timeframe.


