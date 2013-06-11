#!/bin/bash
crontab -l | sed /'~/.datastage.sh'/d
rm ~/.datastage.sh
echo "Uninstall complete. Your datadisk directory still exists, and can be deleted manually if you wish. It will no longer by synced unless you decide to reinstall."