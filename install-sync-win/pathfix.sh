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
	cp -r ~/.ssh "/cygdrive/c/Documents and Settings/$USERNAME/.ssh"
	else
	cp -r "/cygdrive/c/Documents and Settings/$USERNAME/.ssh" ~/.ssh
	fi
	echo "researchdata.sfu.ca,142.58.100.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA+YLx4Hu57l0O8j0BYfetBZh8DmIPasfF8X06FPxfYarjMMiIx40TSzi9MaJnyvxKpKROFy7YyLk+5s5+/gRHlOpHKwiOUpr5f90+U7Q81NkCl/j64CC7hUKOcfXvjWD7w6E1MD6GR6VrKy6IGwPqAmD2C3YqCC+CGsZBHun/m7EYHFCI/8pKuBxb9hLtKlqhjvGxO+VoeMF2sblfwZ2gJ1PlN6T60cieWzunYrMC47ZDFrGd/tsP7FJeoR/rf4ANgYqjS8aoNQTkZBZirl0RnlNoaIOe2bnMFdcY/w7rTYdqnKWlu1mOGkVS01HWTD0SWfRqG8oG7CAps6CP4o8iBQ==" >> "/cygdrive/c/Documents and Settings/$USERNAME/.ssh/known_hosts"
	echo -e 'if ps -W | grep "~[/].datastage"; then\nexit\nelse\nunison.exe "C:\Documents and Settings\'$USERNAME'\datadisk" ssh://'$user'@researchdata.sfu.ca//home/'$user'/.pydiodata -batch -backups -copythreshold 5000 -prefer "C:\Documents and Settings\'$USERNAME'\datadisk" -ignore="Name *.tmp" -ignore="Name *~"\nfi' > "/cygdrive/c/Documents and Settings/$USERNAME/.datastage.sh"
	dos2unix "/cygdrive/c/Documents and Settings/$USERNAME/.datastage.sh"
else
	if [ ! -e "/cygdrive/c/Users/$USERNAME/.ssh/id_rsa.pub" ]
	then
	ssh-keygen -q -t rsa -f ~/.ssh/id_rsa -N "" -C $user'@sfu.ca'
	cp -r ~/.ssh "/cygdrive/c/Users/$USERNAME/.ssh"
	else
	cp -r "/cygdrive/c/Users/$USERNAME/.ssh" ~/.ssh
	fi
	echo "researchdata.sfu.ca,142.58.100.128 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA+YLx4Hu57l0O8j0BYfetBZh8DmIPasfF8X06FPxfYarjMMiIx40TSzi9MaJnyvxKpKROFy7YyLk+5s5+/gRHlOpHKwiOUpr5f90+U7Q81NkCl/j64CC7hUKOcfXvjWD7w6E1MD6GR6VrKy6IGwPqAmD2C3YqCC+CGsZBHun/m7EYHFCI/8pKuBxb9hLtKlqhjvGxO+VoeMF2sblfwZ2gJ1PlN6T60cieWzunYrMC47ZDFrGd/tsP7FJeoR/rf4ANgYqjS8aoNQTkZBZirl0RnlNoaIOe2bnMFdcY/w7rTYdqnKWlu1mOGkVS01HWTD0SWfRqG8oG7CAps6CP4o8iBQ==" >> "/cygdrive/c/Users/$USERNAME/.ssh/known_hosts"
	echo -e 'if ps -W | grep "~[/].datastage"; then\nexit\nelse\nunison.exe C:\Users\'$USERNAME'\datadisk ssh://'$user'@researchdata.sfu.ca//home/'$user'/.pydiodata -batch -backups -copythreshold 5000 -prefer C:\Users\'$USERNAME'\datadisk -ignore="Name *.tmp" -ignore="Name *~"\nfi' > /cygdrive/c/Users/$USERNAME/.datastage.sh
	dos2unix /cygdrive/c/Users/$USERNAME/.datastage.sh
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