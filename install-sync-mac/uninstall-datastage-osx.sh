crontab -l | sed /'~/.datastage.sh'/d
rm ~/.datastage.sh
success=($($CD msgbox --title "DataStage Uninstall" --informative-text "Uninstall complete! TYour datadisk directory still exists, and can be deleted manually if you wish. It will no longer by synced unless you decide to reinstall." --button1 "OK"))