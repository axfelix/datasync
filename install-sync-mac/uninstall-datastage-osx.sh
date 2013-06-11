crontab -l | sed /'~/.datastage.sh'/d
rm ~/.datastage.sh
success=($($CD msgbox --title "DataStage Uninstall" --informative-text "Uninstall complete! Your datadisk directory still exists, and can be deleted manually if you wish. It will no longer be synced unless you decide to reinstall." --button1 "OK"))