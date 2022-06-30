#Entrez un chemin d�acc�s vers votre fichier d�importation CSV

$csv = Import-csv -Path "Chemin CSV" -Delimiter ";"


foreach ($User in $csv)
{
        #Variable
       $Username = $User.username

       #V�rifiez si le compte utilisateur existe d�j� dans AD
       if (Get-ADUser -F {SamAccountName -eq $Username})
       {
               #Si l�utilisateur existe, �ditez un message d�avertissement
               Write-Warning "Le compte utilisateur $Username existe deja dans Active Directory."
       }
       else
       {
        
        #Si un utilisateur n�existe pas, cr�ez un nouveau compte utilisateur
        #Le compte sera cr�� dans I�unit� d�organisation indiqu�e dans la variable $OU du fichier CSV ; n�oubliez pas de changer le nom de domaine dans la variable � -UserPrincipalName �.
        New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@berlin.local" `
            -GivenName $User.firstname `
            -Name "$User.firstname $User.lastname" `
            -Surname $User.lastname `
            -Enabled $True `
            -ChangePasswordAtLogon $True `
            -DisplayName "$User.lastname, $User.firstname" `
            -Description $User.description `
            -Path $User.ou `
            -AccountPassword (convertto-securestring $User.password -AsPlainText -force)
       
       # Ajout de l'utilisateur dans un groupe
       Add-ADGroupMember -Identity $User.groups -Members $Username

       # Cr�ation du dossier PERSO
       New-Item -ItemType Directory -Path C:\Perso -Name $User.username

       # ACL sur le dossier PERSO
       $acl = Get-Acl $User.homedirectory
       $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule((Get-ADUser -Identity $Username).userprincipalname,"DeleteSubdirectoriesAndFiles, Write, ReadAndExecute, Synchronize","Allow")
       $acl.SetAccessRule($AccessRule)
       $acl | Set-Acl $User.homedirectory

       # Ajout du lecteur PERSO
       Set-ADUser -Identity $User.username -HomeDirectory $User.homedirectory -HomeDrive $User.homedrive
    
       } 
}