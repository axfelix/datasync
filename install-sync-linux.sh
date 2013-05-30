if [ -n "$(command -v yum)" ]; then
sudo yum install unison
sudo yum install sshpass
fi

if [ -n "$(command -v apt-get)" ]; then
sudo apt-get install unison
sudo apt-get install sshpass
fi

mkdir ~/datadisk
mkdir -p ~/.unison/backup
chown -R $USER ~/datadisk
# create shortcut to backups dir and readme
ln -s ~/.unison/backup ~/datadisk/backup
echo 'In the event that you and a colleague are working on the same file simultaneously and changes are lost during the sync process, an old version of the file will be created in the backup folder.' > ~/datadisk/readme.txt

# get SFU credentials
echo 'Please input your SFU computing ID: '
read user
echo 'Please input your SFU computing password: '
read -s pass

# test if ssh key already exists; else generate one
if [ ! -e ~/.ssh/id_rsa.pub ];
then
ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N ""
fi
sshpass -p $pass ssh-copy-id $user@datadisk.lib.sfu.ca

if [ $? -eq 0 ]; then
echo "Install complete! The /datadisk folder in your home directory will now be automatically synced with any other machines you have running SFU's DataStage, and will be accessible from a browser at http://datadisk.lib.sfu.ca."
else
echo "Install did not complete successfully. Please verify your credentials and try again. If you continue to have problems, please contact Alex Garnett at garnett@sfu.ca."
fi

echo -e '#test for network conection\nfor interface in $(ls /sys/class/net/ | grep -v lo);\ndo\n  if [[ $(cat /sys/class/net/$interface/carrier) = 1 ]]; then\nunison ~/datadisk ssh://'$user'@datadisk.lib.sfu.ca/srv/datastage/private/'$user' -batch -backups -prefer root -ignore="Name *.tmp" -ignore="Name *~"\nfi\ndone' > ~/.datastage.sh

# Add to /etc/crontab
croncommand="~./datastage.sh"
cronjob="*/5 * * * * $croncommand"
cat <(fgrep -i -v "$croncommand" <(crontab -l)) <(echo "$cronjob") | crontab -