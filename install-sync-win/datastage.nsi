outfile "SFU-datastage.exe"
section
setOutPath $WINDIR
File unison.exe
createDirectory "c:\datastage-cygwin\etc\setup"
setOutPath "c:\datastage-cygwin\etc\setup"
file last-action
file last-cache
file last-mirror
createDirectory $DESKTOP\sfu-datastage-install
setOutPath $DESKTOP\sfu-datastage-install
File setup.exe
File setup.ini
File release.zip
nsUnzip::Extract release.zip /END
delete $DESKTOP\sfu-datastage-install\release.zip
ExecWait 'setup.exe -q -n -L %UserProfile%\Desktop\sfu-datastage-install -R c:\datastage-cygwin'
delete $DESKTOP\sfu-datastage-install\setup.exe
delete $DESKTOP\sfu-datastage-install\setup.ini
setOutPath c:\datastage-cygwin\bin
File install-datastage-win.sh
File pathfix.sh
ExecWait "bash.exe -l -c 'cygrunsrv -I DataSync -p /usr/sbin/cron -a -n'"
ExecWait "net start cron"
ExecWait "bash.exe -l -c pathfix.sh"
ExecWait "bash.exe -l -c install-datastage-win.sh"
delete install-datastage-win.sh
delete pathfix.sh
delete $PROFILE\login.expect
rmdir /r $DESKTOP\sfu-datastage-install\release
rmdir /r $DESKTOP\sfu-datastage-install
sectionEnd