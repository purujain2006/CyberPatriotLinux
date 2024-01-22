for i in `cat /home/debian/dir`; do cd $i; echo $i; echo "---------------------------------------------------------------------------"; find . -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do permissions=$(stat -c "%A" "$file"); sha256=$(sha256sum "$file" | awk '{print $1}'); echo "$permissions $file $sha256"; done; echo "---------------------------------------------------------------------------"; done

sudo for i in `cat /home/debian/dir`; do cd $i; echo $i; echo "---------------------------------------------------------------------------"; find $i/ -maxdepth 1 -type f -print0 | while IFS= read -r -d '' file; do permissions=$(stat -c "%A" "$file"); sha256=$(sha256sum "$file" | awk '{print $1}'); echo "$permissions $file $sha256"; done; echo "---------------------------------------------------------------------------"; done


# Define minimum UID for normal users
MIN_UID=1000

# Define system account names that should never be removed
SYSTEM_ACCOUNTS=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "systemd-network" "systemd-resolve" "syslog" "messagebus" "_apt" "lxd" "uuidd" "dnsmasq" "landscape" "pollinate" "sshd")

echo "Scanning for hidden users..."

# Find users with UID < MIN_UID
users_to_remove=$(awk -F':' -v min_uid="$MIN_UID" '{ if ($3 < min_uid) print $1 }' /etc/passwd)

for user in $users_to_remove; do
    if [[ ! " ${SYSTEM_ACCOUNTS[@]} " =~ " ${user} " ]]; then
        echo "Found hidden user: $user"
        
        # Prompt for confirmation
        read -p "Are you sure you want to remove user $user? [y/N] " -n 1 -r
        echo
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup /etc/passwd, /etc/shadow, and /etc/group
            cp /etc/passwd{,.bak}
            cp /etc/shadow{,.bak}
            cp /etc/group{,.bak}
            
            # Remove user
            userdel -r $user
            if [ $? -eq 0 ]; then
                echo "User $user removed successfully."
            else
                echo "Failed to remove user $user."
            fi
        else
            echo "Aborted removal of user $user."
        fi
    fi
done
