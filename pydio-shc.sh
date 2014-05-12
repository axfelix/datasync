#!/bin/sh

pydiopath='/var/lib/pydio/personal/'$USER
if [ ! -e $pydiopath ]; then
mkdir $pydiopath
fi
chmod -R 775 $pydiopath
chown -R $USER $pydiopath
chgrp -R apache $pydiopath
if [ ! -e ~/.pydiodata ]; then
ln -s '/var/lib/pydio/personal/'$USER ~/.pydiodata
fi
