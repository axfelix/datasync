#!/bin/bash

for userfolder in $(find /home -mindepth 1 -maxdepth 1 -type d)
	do username=$(echo $userfolder | sed -e 's/\/home\///g')
	pydiopath='/var/lib/pydio/personal/'$username
	if [ ! -e $pydiopath ]; then
		mkdir $pydiopath
	fi
	chmod -R 770 $pydiopath
	chown -R $username $pydiopath
	chgrp -R apache $pydiopath
	if [ ! -e /home/$username/.pydiodata ]; then
		ln -s '/var/lib/pydio/personal/'$username /home/$username/.pydiodata
	fi
done