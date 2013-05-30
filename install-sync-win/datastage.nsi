outfile "SFU-datastage.exe"
section
setOutPath $WINDIR
File unison.exe
createDirectory "c:\datastage-cygwin\etc\setup"
setOutPath "c:\datastage-cygwin\etc\setup"
file last-action
file last-cache
file last-mirror
setOutPath $DESKTOP
File setup.exe
File setup.ini
File release.zip
nsUnzip::Extract release.zip /END
delete $DESKTOP\release.zip
ExecWait 'setup.exe -q -n -L %DESKTOP% -R c:\datastage-cygwin'
delete $DESKTOP\setup.exe
delete $DESKTOP\setup.ini
setOutPath c:\datastage-cygwin\bin
File install-datastage-win.sh
File pathfix.sh
ExecWait "bash.exe -l -c 'cygrunsrv -I cron -p /usr/sbin/cron -a -n'"
ExecWait "net start cron"
ExecWait "bash.exe -l -c pathfix.sh"
ExecWait "bash.exe -l -c install-datastage-win.sh"
delete install-datastage-win.sh
delete pathfix.sh
delete $PROFILE\login.expect
rmdir /r $DESKTOP\release
sectionEnd