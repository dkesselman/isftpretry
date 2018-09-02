###CONSTANTS##########
retries=5
user=USRSND
password=PWDUSRSND
ipadd=MYSERVERIPADDR
predir=/SENDING
postdir=/SENDING_DONE/
remotedir=IN
dataarea=ESSELWARE/LFTP01
workdir=/home/ESSELWARE
mailaccount='useralerts@mailserver.com:Passw0rd'
mailfrom='useralerts@mailserver.com'
receptor='groupalerts@mailserver.com'
mailserver='smtp://mailserver.com:587'
files='*'

#######################
# Need to create DATA AREA $dataarea
# as DEC 8.0
#######################

#Initializing Data Area value
system "CHGDTAARA $dataarea VALUE(0)"


for i in {1..$retries} 
do 
        retcode=0
        lftp -C -c "open -u $user,$password  sftp://$ipadd;lcd $predir;cd $remotedir;mput $files"
        retcode=$?
        if [ $retcode -eq 0 ]
        then
		## Exiting loop when exit code equals 0 (no error) ##
                i=$retries
                break
        else
		## Wait 10 seconds when return code differs from 0 (with error) before next attempt ##
                sleep 10
        fi
done

## Check for errors ###
if [ $retcode -gt 0 ]
then
## Send email when return code differs from 0 (with error) ##
        cp $workdir/alertsmail.txt $workdir/alertsmail2.txt
        ls -la $predir  >> $workdir/alertsmail2.txt
        echo "Exit Code : $retcode ">>$workdir/alertsmail2.txt

        curl --url $mailserver --ssl-reqd --mail-from $mailfrom --mail-rcp $receptor --user $mailaccount --insecure --upload-file $workdir/alertsmail2.txt

        mv $predir/* $postdir
fi
system "CHGDTAARA $dataarea VALUE($retcode)"