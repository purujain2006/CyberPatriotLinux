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
echo "deb http://archive.ubuntu.com/ubuntu/ $(lsb_release -c | awk '{print $2}')-updates main universe restricted multiverse" >> /etc/apt/sources.list

#--------------------------#



###############################################################################################################################
