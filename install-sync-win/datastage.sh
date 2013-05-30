if ping -n 1 datadisk.lib.sfu.ca | grep "TTL" ; then
unison ~/Documents/datadisk ssh://${user}@datadisk.lib.sfu.ca/srv/datastage/private/$user -batch -backups -prefer root -ignore="Name *.tmp" -ignore="Name *~"
fi