Client installers for a "local Dropbox" equivalent, using unison (http://www.cis.upenn.edu/~bcpierce/unison/) to do the work of file synchronization. Expects that you have a server with ssh and unison installed on it (http://datadisk.lib.sfu.ca is hardcoded in this example; change to your own URL). Useful for when you want to provide your own cloud-style services without relying on the commercial cloud for whatever reason.

Files go to /home/$user on the server side; change as desired.

Includes Linux, Mac, and Windows installers. Most of the guts of this are just bash, and I like it that way. Platform-specific notes are as follows:

Linux version is tested against Ubuntu 12.04, but should work on any Debian-based distro. An attempt has been made to provide support for RPM-based distros as well, though you'll probably need RPMforge in your sources. If this worries you, stick to Ubuntu.

Mac version should work on OSX 10.5 Leopard and newer. May work on Tiger as well, though I believe there might be issues with ssh-agent. Mac version uses Platypus (http://sveinbjorn.org/platypus; not included) and CocoaDialog to turn bash scripts into user-friendly .apps. Compiled version is included.

Windows version should work on XP or newer (tested on XP SP3 and Win7 x64). Windows version uses NSIS (and the nsUnzip plugin; nsis.sourceforge.net, not included) to deploy a prepared Cygwin installation and run configuration scripts in a single .exe. It's much larger due to the Cygwin dependencies, but it uses the same underlying cron/unison guts as the other platforms. Compiled version is included. This was by far the hardest to create, so I hope you appreciate it most.

Uninstallers are now included. Windows doesn't really follow convention (the "uninstaller" looks like another installer and it doens't appear in add/remove programs), but it's tested and working.

All dependencies are GPL so this is GPL(v3) too.