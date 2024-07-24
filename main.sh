#!/bin/bash
# The above line symbolizes a bash script

# This script will be organized with a preface, code, and comments.
# Preface will tell you everything about the functions and how they're used IN the script.
# They probably have MUCH more functionality than what's shown here.

# The preface will be structured as follows; and the >>>>'s will separate the different functions mentioned

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# syntax for code.

# explanation of code
# explanation of code

# OR

# alternative syntax for code. 

# explanation of alternative code
# explanation of alternative code


# "Example"
# Additional Comment
# Additional Comment

# filename:
# File Content (if applicable)

# Script

# Actual code
# Actual code
# Actual code

# Output

#> Input
# Output
# Output

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



###############################################################################################################################
#                                                                                                                             #
#                                             #FORMATTING THINGS#                                                             #
#                                                                                                                             #
###############################################################################################################################

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# echo "<message>"

# prints <message> to the screen

# OR

# echo "<message>" >> <filepath>

# prints <message> to the END of the file specified by <filepath>
# if the file doesn't exist, it will create it

# OR

# echo "<message>" > <filepath>

# replaces the content of the file specified by <filepath> with <message>
# KEYWORD: REPLACES. It will delete everything in the file and replace it with <message>
# if the file doesn't exist, it will create it


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# function((arg1), (potato) , ...) {   <code>    }

# Creates a function that can be called over and over and over again. This is GREAT for organization.
# Please note that when calling a function, you don't need to use the parentheses.
# Arguments can either be passed with names or numbers.
# $1 = argument 1
# $potato = argument 2;
# $2 = argument 2

# Example

# Script

# function text(){
#   echo "hi $1"
# }
# text "puru" 

# Output
# hi puru

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# printf()

# basically echo but better. It can format strings and print them to the screen.
# thats what all the weird numbers and symbols are in the proceeding code. 
# search up the weird numbers and symbols that generate the format YOU want/need.

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

##############################################################################################

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

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# ;

# is used to chain commands together. They are executed indepedently.

# Example:

#Script

# echo "hi"; echo "bye"

#Output

# hi
# bye

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# read <variable> 

# prompts user for input and stores it in <variable>
# You can name the variable anything but the input will be stored in there for the rest of the script
# Often used after an echo statement that specifies what to input
# you can use variable values by adding a dollar sign in front of <variable> once it's defined

#Example:

# Script

# echo "What is your name?"
# read name
# echo "Hello $name"

# Output:

# What is your name?
#> puru
# Hello puru

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#############################################################################################


#prompts user for current user
#--------------------------#
space
# pwd is a command that prints the directory you are currently sitauted in
# in this case, pwd will give you your home directory and from there 
# will allow you to determine the current user.
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

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# lsb-release -c

# prints the codename of the release of the linux distribution you are using
# codenames are important for accessing the default ubuntu files and configurations.
# some include bionic (Ubu 18), jammy (Ubu 22), and xenial (Ubu 16)
# lsb-release -a prints more version info but dw about it too much

#Example

#Script

# lsb_release -c

#Output

# Codename:       jammy

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# awk '{print $<arg number>}' <filepath>

# awk has a lot of uses besides this but this is the one I use the most.
# prints the <arg number>th field of the input/text
# fields are separated by spaces
# NOTE FOR FUTURE COMMANDS, <filepath> specifies that you want to execute the command
# ON THE CONTENT OF THE FILE. You can replace this with actual content most of the time. 
# This'll be important for the next command.

# OR

# awk '{if <expression> print <thing>}' <filepath>

# This is used to only return values of <thing> that meet the <expression> in the file of <filepath>
# <thing> can a field ($1, $2, etc.) or a mere variable/text 

#Example

# File:

# potato.txt:
# hi puru
# bye puru

# Script

# awk '{print $2}' /home/puru/potato.txt

# Output:

# puru
# puru

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# <command one> | <command 2>

# | or "pipe" is used to take the output of one command and use it as the input for another command.
# It's used to chain commands together, but when something depends on the other.

# Example
# NOTE how in the following script
# we no longer specify <filepath> for awk 
# because lsb outputs the required content.

# Script

# lsb_release -c | awk '{print $2}'


# Output

# jammy


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# gsettings

# gsettings is used to change the settings that are exclusive to the GUI.
# Think of pre-installed settings that are not modifiable through the files on the operating system
# But rather, embedded into the very core of the OS itself.
# Each of these settings is stored in a broad category called a SCHEMA.
# Within a schema, there are several settings called KEYS.
# Within each key, there is a value or a set of values that corresponds to a setting.
# an example value set looks like ['0', '2', 'blue']

# gsettings list-schemas

# List the schemas available in the system

# OR

# gsettings list-key <schema>

# List the key values for schemas specified

# OR 

# gsettings set <schema> <key> 

# set the value of a specific schema, key, and value

# OR

# gsettings list-recurisvely

# list every schema, key, and value in the system

# Example

# Schema: org.gnome.system.proxy
# Key: ignore-hosts
# Value: <we want to assign>

# Script

# gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1']"

# Output

# (No output but the following value is set)

# Schema: org.gnome.system.proxy
# Key: ignore-hosts
# Value: ['localhost', ' 127.0.0.0/8', '::1']"

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

##############################################################################################


#Ensure correct repositories
#--------------------------#
# /etc/apt/sources.list tells Linux where to get the packages for updates
# We want these to be secure, verified, and available repositories, which correspond to the ones listed below
# Format of the file is deb <archive link> <version nickname - type> (main) (restricted) (universe) (multiverse)

echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}') main restricted universe multiverse" > /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-updates main universe restricted multiverse" >> /etc/apt/sources.lists
sudo apt update
#--------------------------#

#Secure Update Settings
#--------------------------#

# Periodic execution

# 1. Periodically updates package lists; automatic sudo apt update. Allows best/most secure version of software
# 2. Auto-download packages needed to upgrade apps. Ready to quickly deploy updates.
# 3. Automatically remove unnecessary packages (sudo apt autoremove). Decreases attack "surface area".
# 4. Automatically upgrade packages. Keeps system constantly up to date, with most secure versions of software.

echo """
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "1";
APT::Periodic::Unattended-Upgrade "1";
""" > /etc/apt/apt.conf.d/10periodic

# Executes upon auto-upgrading + specifics of auto upgrade

# Same as above.

echo """
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
""" > /etc/apt/apt.conf.d/20auto-upgrades

# notify immediately about updates. We want to know as soon as an update is available.
# dbus-x11 is required for notifications

sudo apt-get install dbus-x11
clear

# login as your current user, (su -l $CUSER)
# then, execute the command (-c)
# gsettings sets the update notifier to launch at certain intervals

su -l $CUSER -c 'gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 0'

#--------------------------#

###############################################################################################################################






###############################################################################################################################
#                                                                                                                             #
#                                             #Users, Passwords, Lockout                                                      #
#                                                                                                                             #
###############################################################################################################################

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# cat <filepath>

# prints the content of the file at <filepath> to the screen 
# often used in conjunction with pipes "|"

# Example

# ha.txt

# hi
# ha ha
# hi hi hi

# Script

# cat ha.txt

# Output

# hi
# ha ha
# hi hi hi

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# for i in `<command>`; do <things>; done

# for loop.
# In this particular case, it's used to iterate through the output of a command.
# this is useful for executing based on what a file or a command tells you.
# if it is used with cat/file, it iterates line by line.

# Example

# hmm.txt

# hi 1
# hi 2 
# hi 3

# Script

# for i in `cat hmm.txt`; do echo "number"; done

# Output

# number
# number
# number

# Note how it is the same amount of lines as hmm.txt

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


##############################################################################################

#Add new users 
#----------------------------------------------------------------------------------------

# Writes to the terminal. Copy the password for future use.
space
echo "Adding new users.. with password: dq*eb5,69~n)_-JU<&V8 "
space

# For every user that needs to be added in 'newusers.txt', it executes the useradd command to create the user and adds the user to the users.txt file
# /dev/null 2>&1 is used to not display the output of the useradd command or any of the errors that may occur
# It then changes the password for the user to the password specified above

for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/newusers.txt` ; do sudo useradd $i > /dev/null 2>&1 ; echo $i >> /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt; echo "Added new user " $i ; done

# Writes to the terminal.

echo "Done adding users."
space
#----------------------------------------------------------------------------------------

#Changing Passwords by asking user to place users in passwords.txt
#------------------------------------------------------------------------------------------

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# chpasswd
#> user:pass
#> user:pass
#> (Ctrl + D)

# changes the password of MULTIPLE users.
# it is used by entering the username and then the password separated by a colon

# Example

# chpasswd
#> puru:hihihi
#> tan:hihi2
#> Ken:wopwop
#> (Ctrl + D)

# Output
# (Passwords changed.)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

##############################################################################################

# Write to the terminal.
space
red "Changing passwords..."
space

space

# For every user in the users.txt file, it changes the password to the password specified : dq*eb5,69~n)_-JU<&V8
# Confusing code segment, but echo $i:password | sudo chpasswd will supply the username pasword pairs
# then done will execute the command, functioning as the Ctrl + D

for i in `cat /home/$CUSER/Desktop/CyberPatriotLinux-main/Inputs/users.txt` ; do echo $i:"dq*eb5,69~n)_-JU<&V8" | sudo chpasswd ;  echo "Done changing password for: " $i " ...";  done

# Changes the password for the root user; root is not in the users.txt file by default.
echo "root:dq*eb5,69~n)_-JU<&V8" | sudo chpasswd; echo "Done changing password for: root..."

space
space
echo "Done changing passwords..."
#------------------------------------------------------------------------------------------

#fix non-bash shells for UID 1000+ users
#------------------------------------------------------------------------------------------

#############################    Preface    ##################################################

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# cut -d "<splitter>" -f <field number>

# very similar to awk, but this is simpler
# Splits the input at the <field number>th instance of the <splitter>
# If there are multiple splitters, it will split at the <field number>th instance and the one after it.

# Example

# pass.txt

# puru:hihihi:potato
# tan:hihi2:potato
# Ken:wopwop:potato

# Script
# Note how this script's -f 2 won't include "potato".

# cat pass.txt | cut -d ":" -f 1
# echo " "
# cat pass.txt | cut -d ":" -f 2

# Output

# puru
# tan
# Ken
#
# hihi
# hihi2
# wopwop

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# id -u <user>

# prints the UID of the user specified
# id without the u option prints all the information about the user
# if <user> not specific, tells you about your current user.

# Example

# Script

# id
# echo " "
# id -u

# Output

# uid=1000(puru) gid=1000(puru) groups=1000(puru),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),116(netdev)
#
# 100

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# usermod -s <new login shell> <user>

# changes the <user>'s login shell to the one specified.
# usermod is very useful for several user modifications

# -s is the option for changing the shell

# -l is for locking the user (disabling the account)
# this is important for security reasons: if a user is locked, they can't login

# -U is for unlocking the user. This is the opposite of -l

# Example

# Script

# id
# echo " "
# id -u

# Output

# uid=1000(puru) gid=1000(puru) groups=1000(puru),4(adm),20(dialout),24(cdrom),25(floppy),27(sudo),29(audio),30(dip),44(video),46(plugdev),116(netdev)
#
# 100

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

##############################################################################################

# /etc/passwd is split by user:passwordhash:UID:GID:GECOS:directory:shell
# for every user, which is the first field split by the colon
# it will check if the UID is LESS THAN 1000, which indicates a system user
# not a user that is created to USE the system, but rather one that system processes use.
# we want these users to login through the /bin/false shell, which is a shell that doesn't require a login
# we want all the other system users to login through /bin/bash, which is the default shell and requires a username:password combo
# theses users are the ones that are created to use the system, not the system itself; they have UIDs greater than 999

for user in $(cat /etc/passwd | cut -d ":" -f 1)
	do
    # [] is a condition that needs to be checked
    # if you want to use the output of a command in a condition, or in code
    # you need to use store it as a variable with the $(<command>) syntax.
		if [ $(id -u $user) -lt 1000 ]
		then
      # change the user's shell to /bin/false
			sudo usermod -s /bin/false $user
		fi
    # || is an OR statement
		if [ $(id -u $user) -eq 0 ] || [ $(id -u $user) -gt 999 ]
		then
      # change the user's shell to /bin/bash
			sudo usermod -s /bin/bash $user
		fi
	done
#-----------------------------------------------------------------------------------------

#Look for HIDDEN USERS (humans <1000 UID)
#-----------------------------------------------------------------------------------------
clear

MIN_UID=1000
# A list of the default system users
SYSTEM_ACCOUNTS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "syslog" "messagebus" "_apt" "lxd" "uuidd" "dnsmasq" "landscape" "pollinate" "sshd")
space
echo -n "Scanning for "; green "hidden users..."
space
# Instructions
red "DO NOT REMOVE ANY ***NON-HUMAN/SERVICE*** USERNAMES.  { i.e keep 'mysql' as a user (n), but remove hpotter (y) }"
space

# the awk expression does the following
# -F is similar to cut -d; it splits the message at ":"
# -v assigns a variable min_uid to the value we assigned earlier (1000) --> this is required because we need to access it in the next expression
# after this awk will only print if the third field ($3), which corresponds to the id number of the user is less than mid_uid (1000). It will return the user's name
# which is stored in  field one ($1) (user) of /etc/passwd

system_users=$(awk -F':' -v min_uid="$MIN_UID" '{ if ($3 < min_uid) print $1 }' /etc/passwd)

# Now the list of all users with uids below 1000 is stored in the array variable ($system_users)
# These correspond to all system users AND any hidden users

# For every user in $system_users
for user in $system_users; do
    # the second set of [] establishes the contained expression as True or False
    # if there is NOT a default system account that matches the current user being interrogated in $system_users
    # then it will flag the user as a hidden user and ask if it should be removed.
    if [[ ! " ${SYSTEM_ACCOUNTS[@]} " =~ " ${user} " ]]; then
    	space
        echo  -n "Found possible hidden user: "; yellow "$user"
        space
        read -p "Do you want to remove this user [y/n] " -n 1 -r
	space
 	echo
        # If the reply is a Y or a y, then it will delete the user.
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo deluser $user
            # If the status ($?) is equal to 0 (indicating a success) it will show tell us.
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

#Unlock most users, Lock root
#-----------------------------------------------------------------------------------------

# For every main user, we will unlock their accounts so they can login
for i in `cat /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt` ; do sudo usermod -U $i; sudo passwd -u $i; echo "Unlocked user " $i; done

# utilizing the existing array of system users (in $system_users)
for user in $system_users ; do sudo passwd -l $user; echo "Locked system user " $user; done

# We will lock root so that users cannot login as root from the login screen
# this is important because one of the best ways to brute-force guess a password is to
# attack the root account which is a GUARANTEED account on any linux system.
# If this is locked, the attacker will not only have to guess the password but also the username of the system

sudo passwd -l root
#-----------------------------------------------------------------------------------------

###############################################################################################################################
