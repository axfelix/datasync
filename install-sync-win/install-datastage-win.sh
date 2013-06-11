mkdir ~/datadisk
mkdir -p ~/.unison/backup
echo 'In the event that you and a colleague are working on the same file simultaneously and changes are lost during the sync process, an old version of the file will be created in the backup folder.' > ~/datadisk/readme.txt
mkshortcut -n ~/datadisk/backup.lnk ~/.unison/backup
mkshortcut -n ~/Desktop/datadisk ~/datadisk

echo -e 'if ping -n 1 datadisk.lib.sfu.ca | grep "TTL" ; then\nif ps -W | grep "~[/].datastage"; then\nexit\nelse\nunison.exe ~/Documents/datadisk ssh://'$user'@datadisk.lib.sfu.ca/srv/datastage/private/'$user' -batch -backups -copythreshold 5000 -prefer root -ignore="Name *.tmp" -ignore="Name *~"\nfi\nfi' > ~/.datastage.sh