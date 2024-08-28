Task 1:

    - Go through prototyping/dconf/default_dconf_gsettings and split each line; find the secure settings, and set with "gsettings set"

Task 2:

    - Sort according to CyberPatriot Vulnerability sections and also do constant checks of the CyberPatriot system to check whether/where you lost points/gained them.

Task 3:

    - https://docs.google.com/document/d/1w9UkC05RbW-jXfiOG2cYcfr985P_y0EwWqPSMYzuF-E/edit
    - https://docs.google.com/spreadsheets/d/1iUj0OLS8rhPrhwxYzBTi4aITiEjIX4fjvNiiBHyUtCc/edit?gid=1559276436#gid=1559276436
    - https://ubuntu.com/security/certifications/docs/disa-stig
    
Task 4:

    - Ownership of application directories, such as FTP servers.

Task 5:

    - Add a "What to do if you screwed up" section to the Scripting repository.

Task 6:

    - KERNEL MODULES. (Look into modprobe.d?)

Task 7:

    - Develop an algorithm to check whether permissions are correct (parent-wise)
    - /etc shouldn't have 700 permissions while something within /etc has 755 permissions.

Task 8:

    - Ensure that everything in etc is owned by authorized people, defaults and services. If there are any user owned things, that's BAD.
    - Also add a check before bad users are deleted that checks for all files on the system either mentioning them (grep -RrwF), owned by them, OR named after them