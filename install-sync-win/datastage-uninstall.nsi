outfile "uninstall-SFU-datastage.exe"
section
WriteRegStr "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "DataSync Uninstaller" "C:\Windows\uninstall.exe"
setOutPath $WINDIR
File uninstall.exe
ExecWait "sc delete cron"
sectionEnd