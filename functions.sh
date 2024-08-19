#!/bin/bash

function space(){
    echo " "
    echo " "
}

function red(){
  printf "\033[31m$1\033[0m"
}

function green(){
  printf "\033[32m$1\033[0m"
}

function yellow(){
  printf "\033[33m$1\033[0m"
}

function blue(){
  printf "\033[34m$1\033[0m"
}

function purple(){
  printf "\033[35m$1\033[0m"
}

function dblue(){
  printf "\033[36m$1\033[0m"
}

function ScriptDirectory(){
  SCRIPTDIR=$(realpath $(dirname $0))
  noGUI="DEBIAN_FRONTEND=noninteractive"
  noOutput= "$noOutput"
  oldIFS=$IFS
}

# Remove immutable bits
function RemoveImmutable(){

  clear
  echo "Removing immutable bits..."
  sudo chattr -iaR /etc /home /opt /root /var /usr /srv /bin /sbin

}

# Own Root Directories
# Ownership of application directories
function SystemOwnership(){

    cd /; for i in `ls -a`; do sudo chown root:root $i; done

    sudo chown -R root:root /bin
    sudo chown -R root:root /sbin
    sudo chown -R root:root /etc

    sudo chown root:shadow /etc/gshadow
    sudo chown root:shadow /etc/shadow
    sudo chown root:shadow /etc/shadow-
    sudo chown root:shadow /etc/gshadow-

    for i in `ls /home`; do sudo chown -R $i:$i /home/$i; done

    sudo chown -R root:root /usr/bin
    sudo chown -R root:root /usr/sbin
    clear

}

# Fix ownership of application directories
# ftp is 555 permissions
function AppOwnership(manual){
  echo "Check /etc, /srv, /var, and /opt for any applications that need to be owned by a specific group."
  echo "For example, FTP might require a certain group "whitelotus" to own the /srv/ftp directory."
  echo "FTP directory permissions should be 644"
  echo "This is a manual process, so once you do this in a separate terminal, press a key to continue."
  read pause
}

# Application Updates
function ApplicationUpdate(){
  echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}') main restricted universe multiverse" > /etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://security.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
  echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-updates main universe restricted multiverse" >> /etc/apt/sources.lists
  sudo $noGUI apt update

  echo """
  APT::Periodic::Update-Package-Lists "1";
  APT::Periodic::Download-Upgradeable-Packages "1";
  APT::Periodic::AutocleanInterval "1";
  APT::Periodic::Unattended-Upgrade "1";
  """ > /etc/apt/apt.conf.d/10periodic

  echo """
  APT::Periodic::Update-Package-Lists "1";
  APT::Periodic::Download-Upgradeable-Packages "1";
  APT::Periodic::AutocleanInterval "0";
  APT::Periodic::Unattended-Upgrade "1";
  """ > /etc/apt/apt.conf.d/20auto-upgrades

  sudo $noGUI apt install dbus-x11
  clear

  su -l $(echo $SCRIPTDIR | cut -d / -f3) -c 'gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 0'

  sudo $noGUI apt update
}

function ReplacePoisonedBinaries(){
  sudo $noGUI apt update
  clear
  red "Deleting any suspicious binaries..."
  space
  sudo debsums -c > /tmp/debsums 2>&1
  for i in `cat /tmp/debsums | grep -v missing`; do sudo $noGUI apt install --reinstall $(sudo dpkg -S $i | cut -d : -f1); done
  echo "Done."
}

function CheckPoisonedConfigFiles(manual){
  red "The following config files are different from their defaults:"
  space
  $(sudo debsums -e | grep -v OK | awk {'print $1'})

}

# Add new users
function AddNewUsers(){
  space
  echo "Adding new users.. with password: dq*eb5,69~n)_-JU<&V8 "
  space
  for i in `cat $SCRIPTDIR/Inputs/newusers.txt` ; do sudo useradd $i $noOutput ; sudo usermod -s /bin/bash $i $noOutput; echo $i >> $SCRIPTDIR/Inputs/users.txt; echo "Added new user " $i ; done
  echo "Done adding users."
  space
}

# Changing passwords
function ChangePasswords(){
  space
  red "Changing passwords..."
  space
  space
  for i in `cat $SCRIPTDIR/Inputs/users.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done
  echo "root:dq*eb5,69~n)_-JU<&V8" | sudo chpasswd; echo "Done changing password for: root..."
  space
  space
  echo "Done changing passwords..."
}

# Remove unauthorized shells
function RemoveUnauthorizedShells(){
  for user in $(cat /etc/passwd | cut -d ":" -f1)
	  do
		  if [ $(id -u $user) -lt 1000 ]
		  then
			  sudo usermod -s /bin/false $user
		  fi
		  if [ $(id -u $user) -eq 0 ] || [ $(id -u $user) -gt 999 ]
		  then
			  sudo usermod -s /bin/bash $user
		  fi
	  done
}

# Check for hidden users
function CheckHiddenUsers(manual){
  clear
  MIN_UID=1000
  SYSTEM_ACCOUNTS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "syslog" "messagebus" "_apt" "lxd" "uuidd" "dnsmasq" "landscape" "pollinate" "sshd")
  space
  echo -n "Scanning for "; green "hidden users..."
  space
  red "DO NOT REMOVE ANY ***NON-HUMAN/SERVICE*** USERNAMES.  { i.e keep 'mysql' as a user (n), but remove hpotter (y) }"
  space
  system_users=$(awk -F':' -v min_uid="$MIN_UID" '{ if ($3 < min_uid) print $1 }' /etc/passwd)
  for user in $system_users; 
    do
      if [[ ! " ${SYSTEM_ACCOUNTS[@]} " =~ " ${user} " ]]; then
        space
        echo  -n "Found possible hidden user: "; yellow "$user"
        space
        read -p "Do you want to remove this user [y/n] " -n 1 -r
	    space
 	    echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          sudo deluser $user
          if [ $? -eq 0 ]; then
            echo "Hidden User $user removed successfully."
          else
            echo "FAILED to remove user $user."
          fi
        else
          echo "Aborted removal of user $user."
        fi
        sleep 0.5s
        clear
      fi
    done
}

function DeleteHiddenUsersAuto(){
  hidden=$(sudo cat /etc/passwd | grep /home | grep -v syslog | awk -F ':' '{if ($3 < 1000) print $1}')
  for i in $hidden; do sudo userdel $i; done
}

# Unlock User Accounts
function UnlockUsers(){
  for i in `cat $SCRIPTDIR/Inputs/users.txt` ; do sudo usermod -U $i; sudo passwd -u $i; echo "Unlocked user " $i; done
}

# Lock User Accounts
function LockUsers(){
  for user in $system_users ; do sudo passwd -l $user; echo "Locked system user " $user; done
  sudo passwd -l root
}

function FixAdmins(){
  space
  red "Changing admins..."
  space
  #for loop to read all usernames
  for i in `cat /etc/passwd | cut -d ":" -f1` ; do sudo gpasswd -d $i sudo $noOutput ; sudo gpasswd -d $i adm  $noOutput ; echo "Removed " $i " as an admin"; done
  for i in `cat $SCRIPTDIR/Inputs/admins.txt` ; do sudo gpasswd -a $i sudo $noOutput ; sudo gpasswd -a $i adm $noOutput; echo "Added " $i " as an admin"; done
  space
  echo "Done changing admins "
}

function PasswordExpiration(){
  for line in `cat $SCRIPTDIR/Inputs/users.txt` ; do chage -M 15 -m 6 -W 7 -I 5 $line; done
}

function ZeroUIDUsers(){
  # if the UID is not 0  or less than 999 then set to whatever it is??
  newUID=1090
  newGID=1090
  for i in `egrep ':x:0:' /etc/passwd | grep -v root | cut -d : -f1`; do newUID = $((newUID++)); usermod -u $newUID $i; done
  for i in `egrep ':x:[0-9]*:0:' /etc/passwd | grep -v root | cut -d : -f1`; do newGID = $((newGID++)); groupmod -g $newGID $i; done
}

function enableFirewall(){
  sudo ufw reset
  sudo ufw enable
  sudo ufw default deny incoming
  sudo ufw default deny outgoing
  sudo ufw allow out 53
  sudo ufw allow out 80
  sudo ufw allow out 443
}

function InstallPackages(){
  sudo $noGUI apt install unattended-upgrades -yq
  sudo $noGUI apt install apt -yq
  sudo $noGUI apt install ufw -yq
  sudo $noGUI apt install gufw -yq
  sudo $noGUI apt-mark unhold firefox
  sudo $noGUI apt install firefox -yq
  sudo $noGUI apt install nautilus -yq
  sudo $noGUI apt install linux-generic -yq
  sudo $noGUI apt install debsums -yq
  sudo $noGUI apt install debconf-utils -yq
  sudo $noGUI apt install libpam-pwquality -yq
  sudo $noGUI apt install net-tools -yq
}

function ProhibitedFiles(){
  mediatypes1=("*.mp3" "*.tgz" "*.mov" "*.mp4" "*.avi" "*.mpg" "*.mpeg" "*.flac" "*.m4a" "*.flv" "*.ogg")
  mediatypes2=("*.gif" "*.png" "*.jpg" "*.jpeg")
  for i in ${mediatypes1[@]}; do find / -name $i -type f -delete $noOutput; echo "Deleting $i files"; done
  for i in ${mediatypes2[@]}; do find /home/ -name $i -type f -delete $noOutput; echo "Deleting $i files"; done
  for i in ${mediatypes2[@]}; do find /root/ -name $i -type f -delete $noOutput; echo "Deleting $i files"; done
}

function DeleteBadUsers(){
  grep -E 1[0-9]{3}  /etc/passwd | sed s/:/\ / | awk '{print $1}' > /tmp/allusers
  for i in `grep - Fxvf $SCRIPTDIR/Inputs/users.txt /tmp/allusers` ; do sudo userdel -r $i $noOutput; echo "Deleted user " $i; done
}


function BadPackages(manual){

  # All default gnome games
  sudo $noGUI apt purge iagno lightsoff four-in-a-row gnome-robots pegsolitaire gnome-2048 hitori gnome-klotski gnome-mines gnome-mahjongg gnome-sudoku quadrapassel swell-foop gnome-tetravex gnome-taquin aisleriot gnome-chess five-or-more gnome-nibbles tali -yq $noOutput ; sudo $noGUI apt autoremove -yq $noOutput
  space
  red "The following can be bad packages. Double check and remove:"
  space
  GET $(cat $SCRIPTDIR/InfoFiles/manifests.txt | grep $(lsb_release -c | awk '{print $2}') | awk '{print $2}') | awk '{print $1}' | grep -v telnet | grep -v remmina | grep -v netcat | grep -v ftp | grep -v openssh | grep -v openvpn | grep -v snapd > $SCRIPTDIR/SideProductFiles/BadPackageCheck/basepackages
  dpkg-query -l | tail -n+4 | awk '{print $2}' > $SCRIPTDIR/SideProductFiles/BadPackageCheck/currentpackages

  grep -Fxvf $SCRIPTDIR/SideProductFiles/BadPackageCheck/basepackages $SCRIPTDIR/SideProductFiles/BadPackageCheck/currentpackages | grep -v lib | grep -v python | grep -v gir |grep -v unity | grep -v fonts | grep -v gnome | grep -vF "linux-"| grep -v indicator | grep -v qml | grep -v signon | grep -v qt | grep -vF "ubuntu-" | grep -vF "account-" | grep -v conf | grep -v openssh | grep -v apache2 | grep -v samba | grep -v imagemagick | grep -v GNU | grep -v OpenGl > $SCRIPTDIR/SideProductFiles/BadPackageCheck/differentpackages
  for i in `cat $SCRIPTDIR/SideProductFiles/BadPackageCheck/differentpackages`; do dpkg -l | grep -wF $i >> $SCRIPTDIR/SideProductFiles/BadPackageCheck/DifferentPackagesInfo; done
  cat $SCRIPTDIR/SideProductFiles/BadPackageCheck/DifferentPackagesInfo | grep -v lib >  $SCRIPTDIR/SideProductFiles/BadPackageCheck/removeduplicates.txt; sleep 3s; awk '!a[$0]++' $SCRIPTDIR/SideProductFiles/BadPackageCheck/removeduplicates.txt >  $SCRIPTDIR/SideProductFiles/BadPackageCheck/FinalListofDifferentPackages
  cat  $SCRIPTDIR/SideProductFiles/BadPackageCheck/FinalListofDifferentPackages

  space
  yellow "Type yes once you are done with MANUALLY INSPECTING packages"
  space
  read e

}

function SSHKeyGen(){
  sudo $noGUI apt -yq install expect
  cd /
  mkdir /home/$(echo $SCRIPTDIR | cut -d / -f3)/.ssh
  expect -c "
  spawn ssh-keygen
  expect \"Enter file in which to save the key\"
  send \"/home/$(echo $SCRIPTDIR | cut -d / -f3)/.ssh/id_rsa\r\"
  expect \"Enter passphrase\"
  send \"j@Hn\r\"
  expect \"Enter same passphrase again\"
  send \"j@Hn\r\"
  expect eof
  "
  chmod 600 /home/$(echo $SCRIPTDIR | cut -d / -f3)/.ssh/id_rsa
  chmod 640 /home/$(echo $SCRIPTDIR | cut -d / -f3)/.ssh/id_rsa.pub
}

function CriticalServicePackages(){
  declare -A service2systemctl
  service2systemctl=(["apache2"]="apache2" ["lightdm"]="lightdm" ["phpmyadmin"]="phpmyadmin" ["wordpress"]="wordpress" ["mariadb-server"]="mariadb" ["openvpn"]="openvpn" ["postgresql"]="postgresql" ["mysql-server"]="mysql" ["samba"]="smbd" ["vsftpd"]="vsftpd" ["proftpd"]="proftpd" ["pure-ftpd"]="pure-ftpd" ["ssh"]="ssh" ["bind9"]="bind9")
  service2ufwport=(["apache2"]="80" ["openvpn"]="443" ["postgresql"]="5432" ["mysql-server"]="3306" ["samba"]="139,445" ["vsftpd"]="21" ["proftpd"]="21" ["pure-ftpd"]="21" ["tnftpd"]="69" ["ssh"]="222" ["bind9"]="53")
  SERVICES=()
  for i in `cat $SCRIPTDIR/Inputs/criticalservices.txt`; do sudo $noGUI apt install $i -yq $noOutput; SERVICES+=($i); done
  sudo $noGUI apt autoremove -yq $noOutput

  if [[ "${SERVICES[@]}" =~ "phpmyadmin" ]]; then
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean false"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-remove boolean true"
    sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-upgrade boolean false"
    sudo $noGUI apt install phpmyadmin -yq $noOutput
  fi

  if [[ "${SERVICES[@]}" =~ "lightdm" ]]; then
    sudo debconf-set-selections <<< "gdm3    shared/default-x-display-manager select lightdm"
    sudo debconf-set-selectiosn <<< "lightdm shared/default-x-display-manager select lightdm"
    sudo $noGUI apt install lightdm -yq $noOutput
  fi

  for i in ${SERVICES[@]}; do sudo systemctl enable ${service2systemctl[$i]} $noOutput; sudo systemctl restart ${service2systemctl[$i]} $noOutput; sudo ufw allow ${service2ufwport[$i]} $noOutput; done
  for i in ${!service2systemctl[@]}
    do
      if [[ ! " $(cat $SCRIPTDIR/Inputs/criticalservices.txt) " =~ "$i" ]]; then
          sudo systemctl disable ${service2systemctl[$i]} $noOutput
          sudo systemctl stop ${service2systemctl[$i]} $noOutput
          sudo ufw deny ${service2ufwport[$i]} $noOutput
          sudo $noGUI apt remove --purge $i -yq $noOutput
      fi
    done
}

function Comments(){

  # lighthttpd? for a service?
  # if doing this for config files for all services, have to compare against to isolate
  # proftpd, mysql, mariadb and other services that conflict when installed with their diff versions
  # mysql (mariadb+ mysql)
  # sudo find . -printf '%M %p\n'

  # MUST HAVE below perms
  # chmod o+rx /etc/php5/apache2
  
  # find /PATH executable to find bad files? --> in home directories etc??
  # find . -perm -g=rwx -perm -o=rwx | grep -v ssl | grep -v alsa | grep -v alternatives/ | grep -v /rc | grep -v php | grep -v apache2 | grep -v fonts | grep -v systemd | grep -v network | grep -v mysql
  # but have to compare to default etc files?? --> need better way to check insecure permissions

  # new users need to have correct login shell --> usermod -s 
  # default login shell config file check it
  # check default /etc/skel.
  # explain primary vs secondary groups.

  # https://github.com/UCI-CCDC/CCDC  

  # Make a list of all possible software that can be used to initiate backdoors
  # example the ssl vulnerability backdoor (vecna) 
  # Maybe also set up listeners to check for modifications in the system ( a log but ignores scripts )
  # /etc/shadow not world readable
  # /etc/passwd not world writable
  # /etc/group not world writable
  # Folders (directories) must have 'execute' permissions set (x or 1)
  # cd /etc; sudo chmod 644 -R /*/*.conf
  # cd /etc; sudo chmod 644 -R /*/*.conf

  # The bottom two commands need to be modified to correctly target config files.
  # Install all critical services first.
  # Also double check wordpress mariadb and phpmyadmin password files + configs
  # also consider .ini files (they're also configs)
  # cd /etc; sudo chmod 644 -R /*.conf
  # cd /etc; sudo chmod 644 -R /*.cnf

  # /etc/gshadow not world readable

  # ask them to copy and paste the user passwords?? --> not always justt the main user password

  # tentative symlink code
  # oldIFS=$IFS; IFS=$'\n'; for line in `ls -la | grep "\->"`; do echo $line | awk '{print $9"/"}' | xargs ls -la | wc -l; echo $line | awk '{print $11"/"}' | xargs ls -la | wc -l; done; IFS=$oldIFS
  # wc -l symlinked directories and if there's a difference figure out what's wrong??
  
  # ensure manual check that the default display manager being asked for lightdm is lightdm and not gdm3 (manual checks??)
  # ssh port is now 222
  # DEBIAN_FRONTEND=noninteractive -yq --> for silent installs; but need to reconfigure with debconf-set-selections... ALWAYS CHECK.
  # catch error dpkg --> dpkg --configure -a
  # sudo systemctl reload apache2.service --> IMPORTANT TO RELOAD
  # https://ubuntu.com/server/docs/how-to-install-and-configure-wordpress
  # Use debconf-get-selections for pwquality

  # phpmyadmin      phpmyadmin/password-confirm     password
  # phpmyadmin      phpmyadmin/mysql/admin-pass     password
  # phpmyadmin      phpmyadmin/app-password-confirm password
  
  # Set permissions on those and these files.

  # wordpress       wordpress/mysql/admin-pass      password
  # wordpress       wordpress/mysql/app-pass        password
  # wordpress       wordpress/app-password-confirm  password
  # wordpress       wordpress/password-confirm      password
  # mariadb-server  mariadb-server/root_password    password
  # mariadb-server  mariadb-server/root_password_again password
  # openvpn         openvpn/password-confirm        password

  # python scripts to automatically add to bash scripts??

  # explain xargs
  # maybe log errors to a file like "package apache not found" etc.
  # perl might be malware double check.
  # check that one services folder thats not in service --status-all
  # /sys/fs/cgroup/unified/system.slice/
  # /sys/systemd/system
  # grub mkpdf etc.
  # Linux (permissions, ownership, group settings etc)
  # Apache2/Wordpress
  # MySQL/MariaDB/Postgresql 
  # PHP
  # Samba
  # FTP (vsftpd, proftpd, pure-ftpd, tnftpd)
  # SSH
  # DNS

  # fix path directories from scripting-main to DESKTOP/cyberpatriotlinux-main
  # Get rid of parenthesis () remember
  # double check manual files --> /etc/passwd /etc/group
  # When declaring variables do not forget that it must be a=b and not a = b
  # first is read as assinging a value the second is read as a command
  # MAKE SURE YOU OPEN PORTS FOR CRITICAL SERVICES!!!!!! For example do: sudo ufw allow 22 for SSH
  # Some functions come after updates and instllation
  # Install critical services
  # append & to the functions that don't have update dependencies/aren't manual
  # double check pwquality in InstallPackages()
  # EnableFirewall() needs the critical service
  # check /etc/rc.#.d/ for services that are running on startup.
  # check disown after & to untie to terminal
  # remove echo statements from background non manual functions
  # kernel things moduels etc.
}

# first
# If you want to run this script; remove the () from the functions
# CheckPoisonedConfigFiles(manual) --> CheckPoisonedConfigFiles
# BadPackages(manual) --> BadPackages
# etc.
# Then sudo bash functions.sh

ScriptDirectory()
CheckPoisonedConfigFiles(manual)
ReplacePoisonedBinaries()
RemoveImmutable()
RootOwn()
ApplicationUpdate()
AddNewUsers()
ChangePasswords()
RemoveUnauthorizedShells()
DeleteHiddenUsersAuto()
CheckHiddenUsers(manual)
UnlockUsers()
LockUsers()
FixAdmins()
PasswordExpiration()
InstallPackages()
ProhibitedFiles()
DeleteBadUsers()
BadPackages(manual)