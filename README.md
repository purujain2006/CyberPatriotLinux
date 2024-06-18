Add all authorized users except your own into /home/$CUSER/Desktop/Scripting-main/Scripting-main/users.txt

Add all authorized ADMINS except your own into /home/$CUSER/Desktop/Scripting-main/Scripting-main/admins.txt

Add all users that need to be created to /home/$CUSER/Desktop/Scripting-main/Scripting-main/newusers.txt

Put critical services in /home/$CUSER/Desktop/Scripting-main/Scripting-main/critical_services.txt

  Only list critical services as follows (case and spelling sensitive):
      
          - apache2
          - mysql
          - ssh
          - samba
          - vsftpd
          - proftpd
          - ncftp
          - tnftp
          - tftp

  Everything this Script does: 
  
          - FormattingFunctions
          - LegalBS
          - AliasesAndPoisonedBinaries
          - GetUsername
          - UpdateSourcesAndInstallImportantPackages
          - ChangeUserPasswords
          - FixUserShells
          - FixAdmins
          - AddNewUsers
          - ChangePasswordAge
          - DeleteBadUsers
          - ZeroUidUsers
          - EnableFirewall
          - ManualInstallCriticalServices
          - RemoveKnownBadPackagesAndNoncriticalServices
          - InstallAndUpdateImportantPackages
          - ConfigsAndManualInspection
          - ListAllBadPackagesAndManuallyDelete
          - RestartServicesAndCheckForMaliciousOnes
          - FstabStuff
          - WeirdPermsEtcDirectory
          - PlaintextPasswordFile
          - #AntiVirus (Needs fixing)
          - LockRootAccount
          - ChmodConfigs
          - FullUpdate
          - IpTables

Extract the zip file you downloaded to desktop,put another scripting main folder under scripting main, input user like "tanjiro" for prompt, follow readme instructions (input stuff on new line) 

MAKE SURE YOU GENERATE SSH KEYS
