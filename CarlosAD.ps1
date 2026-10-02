Import-Module ActiveDirectory
do {
    Clear-Host
    Write-Host "1. Info dominio"
    Write-Host "2. Crear OU"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"
    $op = Read-Host "Opción"
    switch ($op) {
        "1" {
            $dom = Get-ADDomain
            Write-Host "Equipo: $env:COMPUTERNAME"
            Write-Host "Dominio: $($dom.DNSRoot)"
            Write-Host "OUs: $((Get-ADOrganizationalUnit -Filter *).Count)"
            Write-Host "Grupos: $((Get-ADGroup -Filter *).Count)"
            Write-Host "Usuarios: $((Get-ADUser -Filter *).Count)"
            Pause
        }
        "2" {
            $ou = Read-Host "Nombre de la OU"
            New-ADOrganizationalUnit -Name $ou -ProtectedFromAccidentalDeletion $false
            Pause
        }
        "3" {
            $g = Read-Host "Nombre del grupo"
            New-ADGroup -Name $g -GroupScope Global
            Pause
        }
        "4" {
            $u = Read-Host "SamAccountName"
            $n = Read-Host "Nombre completo"
            $grp = Read-Host "Grupo al que añadir"
            $pass = Read-Host "Contraseña" -AsSecureString
            New-ADUser -Name $n -SamAccountName $u -AccountPassword $pass `
                -Enabled $true -ChangePasswordAtLogon $true
            Add-ADGroupMember -Identity $grp -Members $u
            Pause
        }
    }
} while ($op -ne "5")