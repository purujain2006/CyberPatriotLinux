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

#red "(message)" makes message red, green "(message)" makes message green, etc.

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

###############################################################################################################################


#prompts user for current user
#------------------------------------------------------------------------------------------
space
yellow "Current working directory is" ; pwd
space
blue "What is the name of the user you are currently using? (ex: haha if /home/haha/Desktop/..."
read CUSER
#------------------------------------------------------------------------------------------




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

#other notify
sudo apt-get install dbus-x11
clear
su -l $CUSER -c 'gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 0'

#--------------------------#



###############################################################################################################################
