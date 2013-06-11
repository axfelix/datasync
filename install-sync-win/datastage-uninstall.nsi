outfile "uninstall-SFU-datastage.exe"
section
WriteRegStr "HKLM" "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" "DataSync Uninstaller" "C:\uninstall.exe"
setOutPath C:\
File uninstall.exe
ExecWait "sc delete cron"
sectionEnd