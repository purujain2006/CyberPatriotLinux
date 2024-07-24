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


function CurrentUser(){
  space
  yellow "Current working directory is" ; pwd
  space
  blue "What is the name of the user you are currently using? (ex: john if /home/john/Desktop/..."
  read CUSER
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
  sudo apt update

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

  sudo apt-get install dbus-x11
  clear

  su -l $CUSER -c 'gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 0'

  sudo apt update
}

function ReplacePoisonedBinaries(){
  sudo apt update
  clear
  red "Deleting any suspicious binaries..."
  space
  sudo debsums -c > /tmp/debsums 2>&1
  for i in `cat /tmp/debsums | grep -v missing`; do sudo apt-get install --reinstall $(sudo dpkg -S $i | cut -d : -f1); done
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
  for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/newusers.txt` ; do sudo useradd $i > /dev/null 2>&1 ; echo $i >> /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt; echo "Added new user " $i ; done
  echo "Done adding users."
  space
}

# Changing passwords
function ChangePasswords(){
  space
  red "Changing passwords..."
  space
  space
  for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done
  echo "root:dq*eb5,69~n)_-JU<&V8" | sudo chpasswd; echo "Done changing password for: root..."
  space
  space
  echo "Done changing passwords..."
}

#Remove unauthorized shells
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

#Unlock User Accounts
function UnlockUsers(){
  for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt` ; do sudo usermod -U $i; sudo passwd -u $i; echo "Unlocked user " $i; done
}

#Lock User Accounts
function LockUsers(){
  for user in $system_users ; do sudo passwd -l $user; echo "Locked system user " $user; done
  sudo passwd -l root
}

function FixAdmins(){
  space
  red "Changing admins..."
  space
  #for loop to read all usernames
  for i in `cat /etc/passwd | cut -d ":" -f1` ; do sudo gpasswd -d $i sudo > /dev/null 2>&1 ; sudo gpasswd -d $i adm  > /dev/null 2>&1 ; echo "Removed " $i " as an admin"; done
  for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/admins.txt` ; do sudo gpasswd -a $i sudo > /dev/null 2>&1 ; sudo gpasswd -a $i adm > /dev/null 2>&1; echo "Added " $i " as an admin"; done
  space
  echo "Done changing admins "
}

function PasswordExpiration(){
  for line in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt` ; do chage -M 15 -m 6 -W 7 -I 5 $line; done
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
  sudo apt install unattended-upgrades -y
  sudo apt install apt -y
  sudo apt install ufw -y
  sudo apt install gufw -y
  sudo apt-mark unhold firefox
  sudo apt install firefox -y
  sudo apt install nautilus -y
  sudo apt install linux-generic -y
  sudo apt install debsums -y
  sudo apt install libpam-pwquality -y
  sudo apt install net-tools -y
}

function ProhibitedFiles(){
  mediatypes1=("*.mp3" "*.tgz" "*.mov" "*.mp4" "*.avi" "*.mpg" "*.mpeg" "*.flac" "*.m4a" "*.flv" "*.ogg")
  mediatypes2=("*.gif" "*.png" "*.jpg" "*.jpeg")
  for i in ${mediatypes1[@]}; do find / -name $i -type f -delete > /dev/null 2>&1; echo "Deleting $i files"; done
  for i in ${mediatypes2[@]}; do find /home/ -name $i -type f -delete > /dev/null 2>&1; echo "Deleting $i files"; done
  for i in ${mediatypes2[@]}; do find /root/ -name $i -type f -delete > /dev/null 2>&1; echo "Deleting $i files"; done
}

function DeleteBadUsers(){
  grep -E 1[0-9]{3}  /etc/passwd | sed s/:/\ / | awk '{print $1}' > /tmp/allusers
  for i in `grep - Fxvf /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt /tmp/allusers` ; do sudo userdel -r $i > /dev/null 2>&1; echo "Deleted user " $i; done
}

# Linux (permissions, ownership, group settings etc)
# Apache2/Wordpress
# MySQL/MariaDB/Postgresql 
# PHP

# Samba
# FTP (vsftpd, proftpd, pure-ftpd, tnftpd)
# SSH
# DNS

# fix path directories from scripting-main to cyberpatriotlinux-main
# Get rid of parenthesis () remember
# double check manual files --> /etc/passwd /etc/group
# When declaring variables do not forget that it must be a=b and not a = b
# first is read as assinging a value the second is read as a command
# MAKE SURE YOU OPEN PORTS FOR CRITICAL SERVICES!!!!!! For example do: sudo ufw allow 22 for SSH
# Some functions come after updates and instllation
# Install critical services
# append & to the functions that don't have update dependencies/aren't manual
# doulbe check pwquality in InstallPackages()
# EnableFirewall() needs the critical service
# check /etc/rc.#.d/ for services that are running on startup.

CheckPoisonedConfigFiles(manual)
ReplacePoisonedBinaries()
CurrentUser(manual) 
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
