
#!/bin/bash
#Waldo's Kali Linux Setup Script!

#Here we set up our options and arguments
for arg; do
    case $arg in
        -d) echo "[*] Running with defaults" 
            DEFAULTS="Y" ;;
    esac
done

for arg; do
    case $arg in
        -e) echo "[*] Express Run!"
            if [ "$2" == "irssi" ] || [ "$2" == "hexchat" ] && [ "$3" == "terminator" ] || [ "$3" == "tmux" ] && [ -z "$4" ] || [ "$4" == "-d" ]; then
                 :
            else
                 echo "[*] ERROR!  Incorrect syntax!"
                 echo "[*] Must choose an IRC client (irssi/hexchat) and a terminal multiplexer (tmux/terminator)"
                 echo "[*] EX: ./kali-setup.sh -e irssi terminator"
                 exit 0
            fi ;;
        -ex) echo "[*] Express Run with no update!"
            if [ "$2" == "irssi" ] || [ "$2" == "hexchat" ] && [ "$3" == "terminator" ] || [ "$3" == "tmux" ] && [ -z "$4" ] || [ "$4" == "-d" ]; then
                      :
            else
                 echo "[*] ERROR!  Incorrect syntax!"
		 echo "[*] Must choose an IRC client (irssi/hexchat) and a terminal multiplexer (tmux/terminator)"
                 echo "[*] EX: ./kali-setup.sh -ex irssi terminator"
                 exit 0
            fi ;;
        -d) : ;;
        -*) echo "[*] Waldo Kali Linux Deluxe Setup Script!"
            echo "[*] Made special for my buddy Kawaxi to quickly setup his Kali Machine!!"
            echo "[*] Usage: $0 (-e)"
            echo "options:"
            echo "-h, --help                    Show brief help"
            echo "-e                            Express install - Bypasses all prompts and just installs the damn thing"
            echo "-ex                           Express install - Bypasses all prompts and just installs the damn thing (no updates)"
            exit 0;;
        *)  dir=$arg ;; #This line is required to pass the target when given.  Gives anything given as an argument without a slash and passes it through to be used for the program.
    esac
done

echo "[*] Waldo Kali Linux Deluxe Setup Script!"
echo "[*] Made special for my buddy Kawaxi to quickly setup his Kali Machine!!"
echo "[*] Usage: $0 (-e)"
echo "[*] Hit CTRL+C at anyime to exit the script"
echo "[*] Hold on to your horses!  I hear they have plenty in Mexico"

#update
echo "[*] Updating System! (I reccomend this boy, not doing this == MISTAKE)"
if [ "$1" == "-e" ] ; then
     CONDITION=Y
elif [ "$1" == "-ex" ] ; then
     echo "[*] Argument EX found, skipping update"
     CONDITION=N
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     sudo apt-get update && sudo apt-get upgrade -y
     echo "[*] If rest of script gives issues reboot machine before continuing."
fi
wait

#change password
echo "[*] Changing password"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     if [ "$DEFAULTS" == "Y" ] ; then
          echo "[*] Leaving Default Password"
          CONDITION=N
     else
          CONDITION=Y
     fi
else
     read -p "Continue? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     passwd
fi
wait

#change lock
echo "[*] Setting up lock screen"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     if [ "$DEFAULTS" == "Y" ] ; then
          echo "[*] Disabling Sleep"
          gsettings set org.gnome.desktop.session idle-delay 0
          echo "[*] Disabling Lock Screen"
          gsettings set org.gnome.desktop.screensaver lock-enabled false
     else
          read -p "[*] Change sleep time.  Enter 0 to never sleep: " sett;
          gsettings set org.gnome.desktop.session idle-delay "$sett"
          echo "[*] Disabling Lock Screen"
          gsettings set org.gnome.desktop.screensaver lock-enabled false
     fi
fi
wait


#intall terminator
echo "[*] Installing Terminator"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     if [ "$3" == "terminator" ]; then
          CONDITION=Y
     else
          echo "[*] Skipping Terminator"
          CONDITION=N
     fi
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     sudo apt-get install terminator -y
fi
wait

#setup tmux
echo "[*] Setting up TMUX"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     if [ "$3" == "tmux" ]; then
          CONDITION=Y
     else
          echo "[*] Skipping Tmux"
          CONDITION=N
     fi
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     git clone https://github.com/waldo-irc/tmux-conf.git
     tmux=$(echo $HOME)
     mv tmux-conf/.tmux.conf $tmux
     echo "[*] Cleaning up"
     rm -R tmux-conf
fi
wait

#install irssi
echo "[*] Installing irssi client"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     if [ "$2" == "irssi" ]; then
          CONDITION=Y
     else
          echo "[*] Skipping irssi"
          CONDITION=N
     fi
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     apt-get install irssi -y
fi
wait

#install hexchat
echo "[*] Installing HexChat"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     if [ "$2" == "hexchat" ]; then
          CONDITION=Y
     else
         echo "[*] Skipping hexchat"
         CONDITION=N
     fi
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     sudo apt-get install hexchat -y
fi
wait

#install Proxychains4
echo "[*] Installing ProxyChains4 client"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     git clone https://github.com/rofl0r/proxychains-ng.git
     cd proxychains-ng
     echo "[*] Running Config"
     ./configure --prefix=/usr --sysconfdir=/etc
     echo "[*] Running Make"
     make
     wait
     echo "[*] Running Make Install"
     make install
     wait
     echo "[*] Running Make Install-Config"
     make install-config
     wait
     cd ../
     echo "[*] Moving executable to /usr/bin filepath"
     mv proxychains-ng/proxychains4 /usr/bin
     echo "[*] Cleaning up"
     rm -R proxychains-ng
fi
wait

#setup apache
echo "[*] Setting up apache server and grabbing LinEnum"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     echo "[*] Starting apache2 webserver"
     service apache2 start
     echo "[*] Setting apache to run on start"
     update-rc.d apache2 enable
     git clone https://github.com/rebootuser/LinEnum.git
     echo "[*] Moving LinEnum.sh to webserver"
     mv LinEnum/LinEnum.sh /var/www/html
     rm -R LinEnum
fi
wait

#install vsftpd
echo "[*] Setting up and installing VSFTPD"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     sudo apt-get install vsftpd -y
     wait
     echo "[*] Enabling VSFTPD to run at start"
     update-rc.d vsftpd start
     if [ "$DEFAULTS" == "Y" ] ; then
          echo "[*] Creating Default FTP Account"
          useradd ftp
          echo "[*] Creating default password for 'ftp'"
          /usr/bin/expect<<EOF
               spawn passwd ftp
               expect "*?assword: "
               send -- "ftp\r"
               expect "*?assword: "
               send -- "ftp\r"
               expect eof
EOF
          mkdir /home/ftp
          chown -R ftp:ftp /home/ftp
          echo "[*] Creating /var/FTP"
          mkdir /var/ftp
          echo "[*] Binding newuser home directory to /var/ftp/$newuser"
          mkdir /var/ftp/ftp
          mount --bind /home/ftp/ /var/ftp/ftp/
          echo "[*] Setting home as /var/ftp/$newuser for user $newuser"
          sudo usermod -d /var/ftp/ftp/ ftp
          echo "[*] Getting VSFTPD Conf"
          git clone https://github.com/waldo-irc/vsftpd-conf.git
          mv vsftpd-conf/vsftpd.conf /etc/vsftpd.conf
          wait
          echo "[*] Cleaning up"
          rm -R vsftpd-conf
     else
          echo "[*] Create a new FTP User"
          read -p "[*] Username?: " newuser;
          useradd $newuser
          echo "[*] Create a new password for $newuser"
          passwd $newuser
          mkdir /home/$newuser
          chown -R $newuser:$newuser /home/$newuser
          echo "[*] Creating /var/FTP"
          mkdir /var/ftp
          echo "[*] Binding newuser home directory to /var/ftp/$newuser"
          mkdir /var/ftp/$newuser
          mount --bind /home/$newuser/ /var/ftp/$newuser/
          echo "[*] Setting home as /var/ftp/$newuser for user $newuser"
          sudo usermod -d /var/ftp/$newuser/ $newuser
          echo "[*] Getting VSFTPD Conf"
          git clone https://github.com/waldo-irc/vsftpd-conf.git
          mv vsftpd-conf/vsftpd.conf /etc/vsftpd.conf
          wait
          echo "[*] Cleaning up"
          rm -R vsftpd-conf
     fi
fi
wait

#configure TFTP
echo "[*] Setting up and installing TFTP on port 69"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     echo "[*] Configuring TFTP to run at start"
     update-rc.d atftpd start
     echo "[*] Creating tftp directory in /tftpboot. Store files to transfer here"
     mkdir /tftpboot
     echo "[*] Transferring TFTP config"
     git clone https://github.com/waldo-irc/tftp-conf.git
     mv tftp-conf/atftpd /etc/default/
     wait
     echo "[*] Cleaning up"
     rm -R tftp-conf
fi
wait

#install Waldo Scripts
echo "[*] Installing wenum and wsmb (You gotta tell me how you like this shit!  You better hit that goddamn Y)"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     git clone https://github.com/waldo-irc/Waldo-Enumeration.git
     echo "[*] Moving to /usr/bin/"
     mv Waldo-Enumeration/wenum /usr/bin/
     echo "[*] Cleaning Up"
     rm -R Waldo-Enumeration
     echo "[*] Finishing up"
     chmod +x /usr/bin/wenum
     wait
     git clone https://github.com/waldo-irc/SMBScan.git
     echo "[*] Moving to /usr/bin/"
     mv SMBScan/wsmb /usr/bin/
     echo "[*] Cleaning Up"
     rm -R SMBScan
     echo "[*] Finishing Up"
     chmod +x /usr/bin/wsmb
     wait
fi
wait

#install dropbox
echo "[*] Installing Dropbox"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     echo "[*] Downloading and installing"
     cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -
     rm ~/.dropbox-dist/VERSION
     mv ~/.dropbox-dist/* /usr/bin
     wait
     echo "[*] Cleaning Up"
     rm -R ~/.dropbox-dist/
     echo "[*] Installed! Run with dropboxd"
fi
wait

#install keyboard
echo "[*] Installing Keyboard Settings"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=N
else
     read -p "Change to Spanish Keyboard? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     echo "[*] Setting Up Keyboard"
     sudo apt-get install x11-xkb-utils -y
     #read -p "[*] Choose a keyboard layout.  en is english, es is spanish: " lang;
     setxkbmap es
     echo "[*] Writing to BashRC for Persistence"
     echo "setxkbmap es" >> ~/.bashrc
fi
wait

#adding bookmark entries
echo "[*] Setting up Bookmarks"
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     read -p "!!!Enter the path of each directory you would like bookmarked - EX:/usr/share and a name for the bookmark (Hit Enter to Continue)";
     echo "[*] 5 Entries max, more can be manually entered. (FTP, TFTP, HTML, and Root Dir / done by default."
     if [ ! -d "/root/.config/gtk-3.0" ]; then
          mkdir ~/.config/gtk-3.0
     fi
     echo file:/// / > ~/.config/gtk-3.0/bookmarks
     echo file:///var/www/html html >> ~/.config/gtk-3.0/bookmarks
     echo file:///tftpboot tftp >> ~/.config/gtk-3.0/bookmarks
     read -p "[*] Enter the FTP user you created to create the FTP bookmark: " ftpuser;
     echo file:///var/ftp/"$ftpuser" ftpd >> ~/.config/gtk-3.0/bookmarks
     for a in $(seq 1 5); do
          read -p "[*] Enter additional entries now EX:/usr/bin.  enter 'exit' when done: " loc;
          if [ "$loc" == "exit" ]; then
               break
          else
               read -p "[*] Enter a name for this bookmark entry EX: bin: " name;
               echo file://"$loc" "$name" >> ~/.config/gtk-3.0/bookmarks
          fi
     done
fi
wait

#install firefox extensions
echo "[*] Installing TamperData, EditCookies, and FoxyProxy"
echo "[*] Make sure Firefox is closed before continuing!  Firefox will open to install each app, accept prompt and close (not restart) firefox to continue script."
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Continue and install? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     echo "[*] Creating Temporary Directory"
     mkdir ~/extensions
     cd ~/extensions
     echo "[*] Installing Tamper Data"
     wget https://addons.mozilla.org/firefox/downloads/latest/tamper-data/addon-966-latest.xpi
     firefox addon-966-latest.xpi
     wait
     read -p "[*] Hit Enter to Continue";
     echo "[*] Installing FoxyProxy"
     wget https://addons.mozilla.org/firefox/downloads/file/400263/foxyproxy_standard-4.5.6-fx+sm+tb.xpi
     firefox foxyproxy_standard-4.5.6-fx+sm+tb.xpi
     wait
     read -p "[*] Hit Enter to Continue";
     echo "[*] Installing Edit Cookies"
     wget https://addons.mozilla.org/firefox/downloads/latest/cookies-manager-plus/addon-92079-latest.xpi
     firefox addon-92079-latest.xpi
     wait
     read -p "[*] Hit Enter to Continue";
     echo "[*] Cleaning up"
     rm -R ~/extensions
     wait
fi
wait

echo "[!!!!] Setup Completed!  Please reboot Kali to finish changes"
#reboot
if [ "$1" == "-e" ] || [ "$1" == "-ex" ]; then
     CONDITION=Y
else
     read -p "Reboot Now? Y/n: " CONDITION;
fi
if [ -z "$CONDITION" ] || [ "$CONDITION" == Y ] || [ "$CONDITION" == y ]; then
     reboot
fi
