cp unison /usr/local/bin/.
chmod 555 /usr/local/bin/unison

mkdir ~/datadisk
mkdir -p ~/.unison/backup
chown -R $USER ~/datadisk
# create shortcut to backups dir and readme
ln -s ~/.unison/backup ~/datadisk/backup
ln -s ~/datadisk ~/Desktop/datadisk

echo 'In the event that you and a colleague are working on the same file simultaneously and changes are lost during the sync process, an old version of the file will be created in the backup folder.' > ~/datadisk/readme.txt

# get SFU credentials – OSX
OLD_IFS="$IFS"
IFS=$'\n'
CD="CocoaDialog.app/Contents/MacOS/CocoaDialog"
user=($($CD standard-inputbox --title "DataSync Install" --informative-text "Enter your SFU Computing ID"))
user=${user[1]}
pass=($($CD standard-inputbox --title "DataSync Install" --informative-text "Enter your SFU Computing Password" --no-show))
pass=${pass[1]}

echo -e 'if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then\nif ps aux | grep "~[/].datastage"; then\nexit\nelse\n/usr/local/bin/unison ~/datadisk ssh://'$user'@researchdata.sfu.ca//home/'$user'/.pydiodata -batch -backups -prefer ~/datadisk -ignore="Name *.tmp" -ignore="Name *~" -rsrc=false -ignore="Name .FBCIndex" -ignore="Name .FBCLockFolder"\nfi' > ~/.datastage.sh

# test if ssh key already exists; else generate one
if [ ! -e ~/.ssh/id_rsa.pub ];
then
ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N "" -C $user'@sfu.ca'
fi

./sshpass -p $pass bash ./ssh-copy-id.sh -i ~/.ssh/id_rsa.pub $user@researchdata.sfu.ca
if [ $? -eq 0 ]; then
success=($($CD msgbox --title "DataSync Install" --informative-text "Install complete! The /datadisk folder in your home directory will now be automatically synced with any other machines you have running SFU's DataSync, and will be accessible from a browser at http://researchdata.sfu.ca/pydio." --button1 "OK"))
else
failure=($($CD msgbox --title "DataSync Install" --informative-text "Install did not complete successfully. Please verify your credentials and try again. If you continue to have problems, please contact Alex Garnett at garnett@sfu.ca." --button1 "OK"))
fi

# Add to /etc/crontab
croncommand="bash /Users/$USER/.datastage.sh  &> /dev/null"
cronjob="*/5 * * * * $croncommand"
cat <(fgrep -i -v "$croncommand" <(crontab -l)) <(echo "$cronjob") | crontab -