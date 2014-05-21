# get SFU credentials
echo 'Please input your SFU computing ID: '
read user
echo 'Please input your SFU computing password: '
read -s pass

# test if ssh key already exists; else generate one
if [ ! -e "/cygdrive/c/Users/$USERNAME" ]
then
	if [ ! -e "/cygdrive/c/Documents and Settings/$USERNAME/.ssh/id_rsa.pub" ]
	then
	ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N "" -C $user'@sfu.ca'
	mkdir "/cygdrive/c/Documents and Settings/$USERNAME/.ssh"
	cp -r ~/.ssh/* "/cygdrive/c/Documents and Settings/$USERNAME/.ssh/"
	else
	mkdir ~/.ssh
	cp -r "/cygdrive/c/Documents and Settings/$USERNAME/.ssh/" ~/.ssh/
	fi
else
	if [ ! -e "/cygdrive/c/Users/$USERNAME/.ssh/id_rsa.pub" ]
	then
	ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N "" -C $user'@sfu.ca'
	mkdir "/cygdrive/c/Users/$USERNAME/.ssh"
	cp -r ~/.ssh/* "/cygdrive/c/Users/$USERNAME/.ssh/"
	else
	mkdir ~/.ssh
	cp -r "/cygdrive/c/Users/$USERNAME/.ssh/" ~/.ssh/
	fi
fi

SSH_ENV=$HOME/.ssh/environment
/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
chmod 600 "${SSH_ENV}"
. "${SSH_ENV}" > /dev/null
/usr/bin/ssh-add

echo -e '#!/usr/bin/expect -f\nspawn ssh-copy-id $argv\nexpect "(yes/no)?"\nsend "yes\n"\nexpect "password:"\nsend "'$pass'\n"\nexpect eof' > ~/login.expect
chmod +x ~/login.expect
~/login.expect $user@researchdata.sfu.ca
rm ~/login.expect

if [ $? -eq 0 ]; then
echo "Install complete! The /datadisk folder in your home directory will now be automatically synced with any other machines you have running SFU's DataSync, and will be accessible from a browser at http://researchdata.sfu.ca/pydio."
else
echo "Install did not complete successfully. Please verify your credentials and try again. If you continue to have problems, please contact Alex Garnett at garnett@sfu.ca."
fi

read -t 100
# Add to /etc/crontab
croncommand="~/.datastage.sh"
cronjob="*/5 * * * * $croncommand"
cat <(fgrep -i -v "$croncommand" <(crontab -l)) <(echo "$cronjob") | crontab -

mkpasswd -l -d -p "$(cygpath -H)" > /etc/passwd