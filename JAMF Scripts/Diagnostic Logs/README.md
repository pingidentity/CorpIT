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
####Config Instructions.
1. Create a user with access to Computers: **Create** and **Read Privileges**
2. Create the basic auth with the above user/pass.
	To create the API simple auth key base encode a username and password, you 		can use an online base64 encoder like:
	https://www.base64encode.org/  
	EG: admin:password becomes **YWRtaW46cGFzc3dvcmQ=**  
3. Upload the script
4. Run as a script in a policy. Putting the Simple Auth Code in Parameter 4
5. Stop Tomcat on all instances
6. Stop MYSQL 
7. Edit my.cnf / my.ini. Make sure to create a backup first.
> The my.cnf file may exist in one or more of the following locations in OS X and Linux:
>/etc/my.cnf
>/etc/mysql/my.cnf
>/usr/local/mysql/my.cnf
>The my.ini file may exist in one or more of the following locations in Windows:
>C:\Program Files\MySQL\MySQL Server 5.6\my.ini
>C:\ProgramData\MySQL\MySQL Server 5.6\my.ini
>C:\my.ini

8. Find the line: max_allowed_packet      = **16M** <--- Change this value to > 40. (there may be two places with this exact string. Put **#** before one of them)
9. Start MYSQL
10. Start Tomcat on all instances
11. Test
	You can verify this setting by uploading a 39M file, in any machine under  		attachments. If you get an error of ERROR_MAX_PACKET then MYSQL is not 			properly configured to handle a bigger file. 

#####Usage.
When the end user runs this, it'll upload that file into the machine's profile under attachments It's important to note, you don't really want to keep all these files on your JSS as it does get stored into the MYSQL database. Remove them after you've downloaded it or remove it at a reasonable timeframe.
