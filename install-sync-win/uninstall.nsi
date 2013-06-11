outfile "uninstall.exe"
section
rmdir /r C:\datastage-cygwin
deleteRegKey HKLM "SOFTWARE\Cygwin"
deleteRegKey HKCU "Software\Cygwin"
SelfDel::del
sectionEnd