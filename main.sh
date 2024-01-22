#!/bin/bash
# The above line symbolizes a bash script


###############################################################################################################################
#                                                                                                                             #
#                                             #FORMATTING THINGS#                                                             #
#                                                                                                                             #
###############################################################################################################################

#Add space for clarity
#--------------------------#
function space(){
    echo " "
    echo " "
}
#--------------------------#

# red "(message)" makes message red, green "(message)" makes message green, etc.
#Red
#--------------------------#
function red(){
  printf "\033[31m$1\033[0m"
}
#--------------------------#

#Green
#--------------------------#
function green(){
  printf "\033[32m$1\033[0m"
}
#--------------------------#

#Yellow
#--------------------------#
function yellow(){
  printf "\033[33m$1\033[0m"
}
#--------------------------#

#Blue
#--------------------------#
function blue(){
  printf "\033[34m$1\033[0m"
}
#--------------------------#

#Purple
#--------------------------#
function purple(){
  printf "\033[35m$1\033[0m"
}
#--------------------------#

#Dark Blue
#--------------------------#
function dblue(){
  printf "\033[36m$1\033[0m"
}
#--------------------------#


#prompts user for current user
#--------------------------#
space
yellow "Current working directory is" ; pwd
space
blue "What is the name of the user you are currently using? (ex: haha if /home/haha/Desktop/..."
read CUSER
#--------------------------#


###############################################################################################################################





###############################################################################################################################
#                                                                                                                             #
#                                             #Configuring Updates#                                                           #
#                                                                                                                             #
###############################################################################################################################


#Ensure correct repositories
#--------------------------#
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}') main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-updates main universe restricted multiverse" >> /etc/apt/sources.lists
sudo apt update
#--------------------------#

#Secure Update Settings
#--------------------------#

#security repository
echo """
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
""" > /etc/apt/apt.conf.d/10periodic

#auto-upgrade + lts support
echo """
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
""" > /etc/apt/apt.conf.d/20auto-upgrades

#notify immediately
sudo apt-get install dbus-x11
clear
su -l $CUSER -c 'gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 0'

#--------------------------#

###############################################################################################################################

#Add new users 
#----------------------------------------------------------------------------------------
space
echo "Adding new users.. with password: dq*eb5,69~n)_-JU<&V8 "
space

for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/newusers.txt` ; do sudo useradd $i > /dev/null 2>&1 ; echo $i >> /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt; echo "Added new user " $i ; done
for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/newusers.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  done

echo "Done adding users."
space
#----------------------------------------------------------------------------------------

#Changing Passwords by asking user to place users in passwords.txt
#------------------------------------------------------------------------------------------
space
red "Changing passwords..."
space
space
for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done
echo "root:dq*eb5,69~n)_-JU<&V8" | sudo chpasswd; echo "Done changing password for: root..."
space
space
echo "Done changing passwords..."
#------------------------------------------------------------------------------------------

#fix non-bash shells for UID 1000+ users
#------------------------------------------------------------------------------------------
for line in $(cat /etc/passwd | cut -d ":" -f 1)
	do
		if [ $(id -u $line) -lt 1000 ]
		then
			sudo usermod -s /bin/false $line
		fi
		
		if [ $(id -u $line) -eq 0 ] || [ $(id -u $line) -gt 999 ]
		then
			sudo usermod -s /bin/bash $line
		fi
	done
#-----------------------------------------------------------------------------------------

#Look for HIDDEN USERS
#-----------------------------------------------------------------------------------------
clear
# Define minimum UID for normal users
MIN_UID=1000

# Define system account names that should never be removed
SYSTEM_ACCOUNTS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "syslog" "messagebus" "_apt" "lxd" "uuidd" "dnsmasq" "landscape" "pollinate" "sshd")

space
echo -n "Scanning for "; green "hidden users..."
space
red "DO NOT REMOVE ANY ***NON-HUMAN/SERVICE*** USERNAMES.  { i.e keep 'mysql' as a user (n), but remove hpotter (y) }"
space

# Find users with UID < MIN_UID
users_to_remove=$(awk -F':' -v min_uid="$MIN_UID" '{ if ($3 < min_uid) print $1 }' /etc/passwd)

for user in $users_to_remove; do
    if [[ ! " ${SYSTEM_ACCOUNTS[@]} " =~ " ${user} " ]]; then
    	space
        echo  -n "Found possible hidden user: "; yellow "$user"
        space
        # Prompt for confirmation
        read -p "Do you want to remove this user [y/n] " -n 1 -r
	space
 	echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Remove user
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
#-----------------------------------------------------------------------------------------

