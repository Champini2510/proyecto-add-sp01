#Importa el módulo de Active Directory
Import-Module ActiveDirectory

#Bucle principal del menú, se repite hasta elegir Salir
do {
    #Limpia la pantalla para que el menú se vea siempre limpio
    Clear-Host
 
    #Muestra las opciones disponibles al usuario
    Write-Host "1. Info dominio"
    Write-Host "2. Crear OU"
    Write-Host "3. Crear grupo"
    Write-Host "4. Crear usuario"
    Write-Host "5. Salir"

    #Pide al usuario que escriba el número de la opción
    $op = Read-Host "Opción"
    #Según el valor de $op, ejecuta un bloque u otro
    switch ($op) {

        #OPCIÓN 1: Mostrar información del dominio
        "1" {
            # Obtiene los datos generales del dominio actual
            $dom = Get-ADDomain

            # Nombre del equipo donde se ejecuta el script
            Write-Host "Equipo: $env:COMPUTERNAME"

            # Nombre DNS del dominio (ej. carlos.aws)
            Write-Host "Dominio: $($dom.DNSRoot)"

            # Cuenta cuántas Unidades Organizativas existen
            Write-Host "OUs: $((Get-ADOrganizationalUnit -Filter *).Count)"

            # Cuenta cuántos grupos existen
            Write-Host "Grupos: $((Get-ADGroup -Filter *).Count)"

            # Cuenta cuántos usuarios existen
            Write-Host "Usuarios: $((Get-ADUser -Filter *).Count)"

            # Pausa la ejecución hasta que el usuario pulse una tecla para poder leer
            Pause
        }

        #OPCIÓN 2: Crear una nueva Unidad Organizativa
        "2" {
            # Pide el nombre de la nueva OU
            $ou = Read-Host "Nombre de la OU"

            # Crea la OU. ProtectedFromAccidentalDeletion a $false
            # permite poder borrarla más adelante sin complicaciones
            New-ADOrganizationalUnit -Name $ou -ProtectedFromAccidentalDeletion $false

            Pause
        }

        #OPCIÓN 3: Crear un nuevo grupo
        "3" {
            #Pide el nombre del nuevo grupo
            $g = Read-Host "Nombre del grupo"

            #Crea el grupo con ámbito Global (el más habitual para grupos de usuarios)
            New-ADGroup -Name $g -GroupScope Global

            Pause
        }

        #OPCIÓN 4: Crear un nuevo usuario
        "4" {
            #Nombre de inicio de sesión (SamAccountName)
            $u = Read-Host "SamAccountName"

            #Nombre completo que aparecerá en el directorio
            $n = Read-Host "Nombre completo"

            #Grupo al que se añadirá el nuevo usuario
            $grp = Read-Host "Grupo al que añadir"

            #Contraseña inicial, pedida como texto seguro (no se muestra en pantalla)
            $pass = Read-Host "Contraseña" -AsSecureString

            #Crea el usuario:
            #Enabled $true activa la cuenta inmediatamente
            #ChangePasswordAtLogon $true obliga a cambiar la contraseña en el primer inicio de sesión
            New-ADUser -Name $n -SamAccountName $u -AccountPassword $pass `
                -Enabled $true -ChangePasswordAtLogon $true

            #Añade al usuario recién creado al grupo indicado
            Add-ADGroupMember -Identity $grp -Members $u

            Pause
        }
    }
#La condición de salida: el bucle sigue mientras $op no sea "5"
} while ($op -ne "5")
