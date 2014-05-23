#!/bin/bash

pydiopath='/var/lib/pydio/personal/'$USER
chmod -R 770 $pydiopath
if [ ! -e ~/.pydiodata ]; then
ln -s '/var/lib/pydio/personal/'$USER ~/.pydiodata
fi
