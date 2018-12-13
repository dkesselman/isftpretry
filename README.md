# isftpretry
IBM i - SFTP file transfer with retries - Bash script


This BASH script is ready to be used on IBM i . Please, pay attention to system requirements.

System Requirements
-------------------

* Desirable:
  * IBM i V7R2 or newer (maybe works on V7R1)
  * YUM (also works with Perzl tools)
  * SSH (it's not mandatory, but really useful)
  
* Mandatory: 
  * cURL
  * lftp
  
You need to create your IFS directories and change constants so they reflect real paths:
* script
* OUTBOX
* OUTBOX_OLD (already processed files)

Also need to create your Data Area where you'll receive program return code.
Finally, you need to adjust header file alertsmail.txt 

This program sends files from OUTBOX folder to the destination server. If something goes wrong during file transfer performs as many retries as you need ($retries constant).
When (if) all retries are gone, sends an email notification.

Data Area is used to return a value, so you can use a CL to call this script:
  * 0=success
  * any other value=error
  
