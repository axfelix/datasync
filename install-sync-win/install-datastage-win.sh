mkdir ~/datadisk
mkdir -p ~/.unison/backup
echo 'In the event that you and a colleague are working on the same file simultaneously and changes are lost during the sync process, an old version of the file will be created in the backup folder.' > ~/datadisk/readme.txt
mkshortcut -n ~/datadisk/backup.lnk ~/.unison/backup
mkshortcut -n ~/Desktop/datadisk ~/datadisk