#
# Created by: lucas.cueff[at]lucas-cueff.com
#
# v0.1 : 
# - connect / disconnect session based on login/password authent mode
# - Users, hosts, groups (not hostgroup), privilege, permission, role, IPA environnement and IPA config APIs implemented
#
# Released on: 10/2018
#
#'(c) 2018 lucas-cueff.com - Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).'

<#
	.SYNOPSIS 
	Powershell cmdlets to use FreeIPA JSONRPC admin web API

	.DESCRIPTION
    Manage-FreeIPA.psm1 module provides a commandline interface to manage your FreeIPA/IPA infrastructure from Powershell (Core/Classic - Windows/Linux/Mac Os).
    cmdlet alias respect the Powershell verb naming convention. All the parameters are based on the IPA Python cli embedded in the product.
    For more information on the FreeIPA API, please connect to thw web interface on your IPA Server : https://yourIPA.tld/ipa/ui/#/p/apibrowser/type=command
    Note : Don't forget to trust your IPA AC / ssl certificate locally before using the Powershell Module.
	
	.EXAMPLE
    C:\PS> import-module Manage-FreeIPA.psm1
    
    .EXTERNALHELP
    Manage-FreeIPA-help.xml
#>
Function Set-FreeIPAAPICredentials {
    [cmdletbinding()]
    Param (
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
          [SecureString]$AdminLogin,
      [parameter(Mandatory=$true)]
      [ValidateNotNullOrEmpty()]
          [SecureString]$AdminPassword,
      [parameter(Mandatory=$false)]
          [switch]$Remove,
      [parameter(Mandatory=$false)]
          [switch]$EncryptKeyInLocalFile,
      [parameter(Mandatory=$false)]
      [ValidateNotNullOrEmpty()]
          [securestring]$MasterPassword
    )
    if ($Remove.IsPresent) {
      $global:FreeIPAAPICredentials = $Null
    } Else {
        $global:FreeIPAAPICredentials = @{
            user = $AdminLogin
            password = $AdminPassword
        }
      If ($EncryptKeyInLocalFile.IsPresent) {
          If (!$MasterPassword -or !$AdminPassword) {
              Write-warning "Please provide a valid Master Password to protect the credential storage on disk and a valid credential"
              throw 'no credential or master password'
          } Else {
              $SaltBytes = New-Object byte[] 32
              $RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
              $RNG.GetBytes($SaltBytes)
              $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $MasterPassword
              $Rfc2898Deriver = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $Credentials.GetNetworkCredential().Password, $SaltBytes
              $KeyBytes  = $Rfc2898Deriver.GetBytes(32)
              $EncryptedPass = $AdminPassword | ConvertFrom-SecureString -key $KeyBytes
              $EncryptedLogin = $AdminLogin | ConvertFrom-SecureString -key $KeyBytes
              $ObjConfigFreeIPA = @{
                  Salt = $SaltBytes
                  EncryptedAdminSecret = $EncryptedPass
                  EncryptedAdminAccount = $EncryptedLogin
              }
              $FolderName = 'Manage-FreeIPA'
              $ConfigName = 'Manage-FreeIPA.xml'
              if (!(Test-Path -Path "$($env:AppData)\$FolderName")) {
                  New-Item -ItemType directory -Path "$($env:AppData)\$FolderName" | Out-Null
              }
              if (test-path "$($env:AppData)\$FolderName\$ConfigName") {
                  Remove-item -Path "$($env:AppData)\$FolderName\$ConfigName" -Force | out-null
              }
              $ObjConfigFreeIPA | Export-Clixml "$($env:AppData)\$FolderName\$ConfigName"
          }	
      }
    }
  }
Function Import-FreeIPAAPICrendentials {
      [CmdletBinding()]
      Param(
          [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
          [ValidateNotNullOrEmpty()]
          [securestring]$MasterPassword
      )
      process {
        $FolderName = 'Manage-FreeIPA'
        $ConfigName = 'Manage-FreeIPA.xml'
          if (!(Test-Path "$($env:AppData)\$($FolderName)\$($ConfigName)")){
              Write-warning 'Configuration file has not been set, Set-FreeIPAAPICredentials to configure the credentials.'
              throw 'error config file not found'
          }
          $ObjConfigFreeIPA = Import-Clixml "$($env:AppData)\$($FolderName)\$($ConfigName)"
          $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $MasterPassword
          try {
              $Rfc2898Deriver = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $Credentials.GetNetworkCredential().Password, $ObjConfigFreeIPA.Salt
              $KeyBytes  = $Rfc2898Deriver.GetBytes(32)
              $SecStringPass = ConvertTo-SecureString -Key $KeyBytes $ObjConfigFreeIPA.EncryptedAdminSecret
              $SecStringLogin = ConvertTo-SecureString -Key $KeyBytes $ObjConfigFreeIPA.EncryptedAdminAccount
              $global:FreeIPAAPICredentials = @{
                  user = $SecStringLogin
                  password = $SecStringPass
              }
          } catch {
              write-warning "Not able to set correctly your credential, your passphrase my be incorrect"
              write-verbose -message "Error Type: $($_.Exception.GetType().FullName)"
              write-verbose -message "Error Message: $($_.Exception.Message)"
          }
      }
  }
Function Set-FreeIPAAPIServerConfig {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "(http[s]?)(:\/\/)([^\s,]+)"})]
            [String]$URL,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$ClientVersion
    )
    process {
        $global:FreeIPAAPIServerConfig = @{
            ServerURL = $URL
        }
        if ($ClientVersion) {
            $global:FreeIPAAPIServerConfig.add('ClientVersion',$ClientVersion)
        } else {
            $global:FreeIPAAPIServerConfig.add('ClientVersion',"2.229")
        }
    }
  }
Function Get-FreeIPAAPIAuthenticationCookie {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "(http[s]?)(:\/\/)([^\s,]+)"})]
            [String]$URL,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [SecureString]$AdminLogin,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [SecureString]$AdminPassword,
        [parameter(Mandatory=$false)]
            [switch]$UseCachedURLandCredentials,
        [parameter(Mandatory=$false)]
            [switch]$CloseAllRemoteSession
    )
    if ($CloseAllRemoteSession.IsPresent) {
        Invoke-FreeIPAAPISessionLogout
    } else {
        if (!($UseCachedURLandCredentials.IsPresent)) {
            if ($URL -and $AdminLogin -and $AdminPassword) {
                $global:FreeIPAAPICredentials = @{
                    user = $AdminLogin
                    password = $AdminPassword
                }
                Set-FreeIPAAPIServerConfig -URL $URL

            } else {
                write-warning "if UseCachedURLandCredentials switch is not used URL, AdminLogin, AdminPassword parameters must be used"
                throw 'AdminLogin, AdminPassword parameters must be used'
            }
        }
        try {
            $SecureStringPassToBSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($global:FreeIPAAPICredentials.password)
            $SecureStringLoginToBSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($global:FreeIPAAPICredentials.user)
            $BSTRCredentials = @{
                user = [Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringLoginToBSTR)
                password = [Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringPassToBSTR) 
            }
            $FreeIPALogin = Invoke-WebRequest "$($global:FreeIPAAPIServerConfig.ServerURL)/ipa/session/login_password" -Session 'FunctionFreeIPASession' -Body $BSTRCredentials -Method 'POST'
        } catch [System.Net.Http.HttpRequestException] {
            switch ($_.Exception.Response.StatusCode.value__) {
                404 { 
                        Write-error -message "Please check that /ipa/session/login_password is available on your FreeIPA server"
                    }
                Default {
                            write-error -message "HTTP Error Code $($_.Exception.Response.StatusCode.Value__) with error message:$($_.Exception.Response.StatusDescription)"
                        }
            }
            Break
        } catch [System.Exception] {
            write-error -message "other error encountered - error message:$($_.Exception.message)"
            break
        }
        $global:FreeIPASession = $FunctionFreeIPASession
        $FreeIPALogin
    }
}
Function Invoke-FreeIPAAPIRole_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $RoleShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $RoleShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $RoleShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $RoleShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $RoleShowObject = New-Object psobject -property @{
            id		= 0
            method	= "role_show/1"
            params  = @(@($cn),$RoleShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleShowObject
        }
    }
}
Function Invoke-FreeIPAAPIConfig_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $ConfigShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($All.IsPresent) {
            $ConfigShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $ConfigShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $ConfigShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $ConfigShowObject = New-Object psobject -property @{
            id		= 0
            method	= "config_show/1"
            params  = @(@(),$ConfigShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $ConfigShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $ConfigShowObject
        }
    }   
}
Function Invoke-FreeIPAAPIPermission_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PermissionShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $PermissionShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $PermissionShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $PermissionShowObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_show/1"
            params  = @(@($cn),$PermissionShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionShowObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $UserShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $UserShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $UserShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $UserShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $UserShowObject = New-Object psobject -property @{
            id		= 0
            method	= "user_show/1"
            params  = @(@($UID),$UserShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserShowObject
        }
    }
}
Function Invoke-FreeIPAAPIHost_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$FQDN,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $HostShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $HostShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $HostShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $HostShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $HostShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $HostShowObject = New-Object psobject -property @{
            id		= 0
            method	= "host_show/1"
            params  = @(@($FQDN),$HostShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $HostShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $HostShowObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$CN,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PrivilegeShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $PrivilegeShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $PrivilegeShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $PrivilegeShowObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_show/1"
            params  = @(@($CN),$PrivilegeShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeShowObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Status {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserStatusParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($All.IsPresent) {
            $UserStatusParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $UserStatusObject = New-Object psobject -property @{
            id		= 0
            method	= "user_status/1"
            params  = @(@($UID),$UserStatusParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserStatusObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserStatusObject
        }
    }
}
Function Invoke-FreeIPAHost_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Hostname,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Locality,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Location,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Platform,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$OS,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidatePattern("(?!^[0-9]+$)^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$")]
            [String[]]$EnrollByUsers,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*$")]
            [String[]]$InHostGroups,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*$")]
            [String[]]$InNetGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$ManHosts,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$ManByHosts,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InSudoRules,
        [parameter(Mandatory=$false)]
        [ValidatePattern("(?!^[0-9]+$)^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$")]
            [String[]]$NotEnrollByUsers,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*$")]
            [String[]]$NotInHostGroups,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*$")]
            [String[]]$NotInNetGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInSudoRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotManHosts,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotManByHosts,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $HostFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $HostFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($Locality) {
            $HostFindParams | Add-Member -NotePropertyName l -NotePropertyValue $Locality
        }
        if ($ManHosts) {
            $HostFindParams | Add-Member -NotePropertyName man_host -NotePropertyValue $ManHosts
        }
        if ($ManByHosts) {
            $HostFindParams | Add-Member -NotePropertyName man_by_host -NotePropertyValue $ManByHosts
        }
        if ($Platform) {
            $HostFindParams | Add-Member -NotePropertyName nshardwareplatform -NotePropertyValue $Platform
        }
        if ($OS) {
            $HostFindParams | Add-Member -NotePropertyName nsosversion -NotePropertyValue $OS
        }
        if ($Location) {
            $HostFindParams | Add-Member -NotePropertyName nshostlocation -NotePropertyValue $Location
        }
        if ($Hostname) {
            $HostFindParams | Add-Member -NotePropertyName fqdn -NotePropertyValue $Hostname
        }
        if ($sizelimit) {
            $HostFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $HostFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($EnrollByUsers) {
            $HostFindParams | Add-Member -NotePropertyName enroll_by_user -NotePropertyValue $EnrollByUsers
        }
        if ($InHostGroups) {
            $HostFindParams | Add-Member -NotePropertyName in_hostgroup -NotePropertyValue $InHostGroups
        }
        if ($InNetGroups) {
            $HostFindParams | Add-Member -NotePropertyName in_netgroup -NotePropertyValue $InNetGroups
        }
        if ($InRoles) {
            $HostFindParams | Add-Member -NotePropertyName in_role -NotePropertyValue $InRoles
        }
        if ($InHBACRules) {
            $HostFindParams | Add-Member -NotePropertyName in_hbacrule -NotePropertyValue $InHBACRules
        }
        if ($InSudoRules) {
            $HostFindParams | Add-Member -NotePropertyName in_sudorule -NotePropertyValue $InSudoRules
        }
        if ($NotEnrollByUsers) {
            $HostFindParams | Add-Member -NotePropertyName not_enroll_by_user -NotePropertyValue $NotEnrollByUsers
        }
        if ($NotInHostGroups) {
            $HostFindParams | Add-Member -NotePropertyName not_in_hostgroup -NotePropertyValue $NotInHostGroups
        }
        if ($NotInNetGroups) {
            $HostFindParams | Add-Member -NotePropertyName not_in_hostgroup -NotePropertyValue $NotInNetGroups
        }
        if ($NotInRoles) {
            $HostFindParams | Add-Member -NotePropertyName not_in_role -NotePropertyValue $NotInRoles
        }
        if ($NotInHBACRules) {
            $HostFindParams | Add-Member -NotePropertyName not_in_hbacrule -NotePropertyValue $NotInHBACRules
        }
        if ($NotInSudoRules) {
            $HostFindParams | Add-Member -NotePropertyName not_in_sudorule -NotePropertyValue $NotInSudoRules
        }
        if ($NotManHosts) {
            $HostFindParams | Add-Member -NotePropertyName not_man_host -NotePropertyValue $NotManHosts
        }
        if ($NotManByHosts) {
            $HostFindParams | Add-Member -NotePropertyName not_man_by_host -NotePropertyValue $NotManByHosts
        }
        if ($All.IsPresent) {
            $HostFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $HostFindObject = New-Object psobject -property @{
            id		= 0
            method	= "host_find/1"
            params  = @(@($Search),$HostFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $HostFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $HostFindObject
        }
    }    
}
Function Invoke-FreeIPAAPIUser_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
            [switch]$Preserved,
        [parameter(Mandatory=$false)]
            [switch]$Disabled,
        [parameter(Mandatory=$false)]
            [switch]$Whoami,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InSudoRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInSudoRules,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Disabled.IsPresent) {
            $UserFindParams | Add-Member -NotePropertyName nsaccountlock -NotePropertyValue $true
        }
        if ($Preserved.IsPresent) {
            $UserFindParams | Add-Member -NotePropertyName preserved -NotePropertyValue $true
        }
        if ($Whoami.IsPresent) {
            $UserFindParams | Add-Member -NotePropertyName whoami -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $UserFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($sizelimit) {
            $UserFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $UserFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($InGroups) {
            $UserFindParams | Add-Member -NotePropertyName in_group -NotePropertyValue $InGroups
        }
        if ($InRoles) {
            $UserFindParams | Add-Member -NotePropertyName in_role -NotePropertyValue $InRoles
        }
        if ($InHBACRules) {
            $UserFindParams | Add-Member -NotePropertyName in_hbacrule -NotePropertyValue $InHBACRules
        }
        if ($InSudoRules) {
            $UserFindParams | Add-Member -NotePropertyName in_sudorule -NotePropertyValue $InSudoRules
        }
        if ($NotInGroups) {
            $UserFindParams | Add-Member -NotePropertyName not_in_group -NotePropertyValue $NotInGroups
        }
        if ($NotInRoles) {
            $UserFindParams | Add-Member -NotePropertyName not_in_role -NotePropertyValue $NotInRoles
        }
        if ($NotInHBACRules) {
            $UserFindParams | Add-Member -NotePropertyName not_in_hbacrule -NotePropertyValue $NotInHBACRules
        }
        if ($NotInSudoRules) {
            $UserFindParams | Add-Member -NotePropertyName not_in_sudorule -NotePropertyValue $NotInSudoRules
        }
        if ($All.IsPresent) {
            $UserFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $UserFindObject = New-Object psobject -property @{
            id		= 0
            method	= "user_find/1"
            params  = @(@($Search),$UserFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserFindObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Name,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$Desc,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Name) {
            $RoleFindParams | Add-Member -NotePropertyName private -NotePropertyValue $Name
        }
        if ($Desc) {
            $RoleFindParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($NoMembers.IsPresent) {
            $RoleFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($sizelimit) {
            $RoleFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $RoleFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($All.IsPresent) {
            $RoleFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $RoleFindObject = New-Object psobject -property @{
            id		= 0
            method	= "role_find/1"
            params  = @(@($Search),$RoleFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleFindObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Name,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [string]$Desc,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Name) {
            $PrivilegeFindParams | Add-Member -NotePropertyName private -NotePropertyValue $Name
        }
        if ($Desc) {
            $PrivilegeFindParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($sizelimit) {
            $PrivilegeFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $PrivilegeFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($All.IsPresent) {
            $PrivilegeFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $PrivilegeFindObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_find/1"
            params  = @(@($Search),$PrivilegeFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeFindObject
        }
    }
}
Function Invoke-FreeIPAAPIPermission_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$Name,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Right,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Attrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$IncludedAttrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$ExcludedAttrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$DefaultAttrs,
        [parameter(Mandatory=$false)]
        [ValidateSet("permission", "all", "anonymous")]
            [String]$BindType,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Subtree,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Target,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetTo,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetFrom,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$RawFilter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$MemberOf,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$TargetGroup,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Type,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Name) {
            $PermissionFindParams | Add-Member -NotePropertyName private -NotePropertyValue $Name
        }
        if ($NoMembers.IsPresent) {
            $PermissionFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($sizelimit) {
            $PermissionFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $PermissionFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($Right) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermright -NotePropertyValue $Right
        }
        if ($Attrs) {
            $PermissionFindParams | Add-Member -NotePropertyName attrs -NotePropertyValue $Attrs
        }
        if ($includedattrs) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermincludedattr -NotePropertyValue $includedattrs
        }
        if ($excludedattrs) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermexcludedattr -NotePropertyValue $excludedattrs
        }
        if ($DefaultAttrs) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermdefaultattr -NotePropertyValue $defaultattrs
        }
        if ($BindType) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermbindruletype -NotePropertyValue $BindType
        }
        if ($subtree) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermlocation -NotePropertyValue $subtree
        }
        if ($filter) {
            $PermissionFindParams | Add-Member -NotePropertyName extratargetfilter -NotePropertyValue $filter
        }
        if ($rawfilter) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermtargetfilter -NotePropertyValue $rawfilter
        }
        if ($Target) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermtarget -NotePropertyValue $Target
        }
        if ($TargetTo) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermtargetto -NotePropertyValue $TargetTo
        }
        if ($TargetFrom) {
            $PermissionFindParams | Add-Member -NotePropertyName ipapermtargetfrom -NotePropertyValue $TargetFrom
        }
        if ($MemberOf) {
            $PermissionFindParams | Add-Member -NotePropertyName memberof -NotePropertyValue $MemberOf
        }
        if ($targetgroup) {
            $PermissionFindParams | Add-Member -NotePropertyName targetgroup -NotePropertyValue $targetgroup
        }
        if ($Type) {
            $PermissionFindParams | Add-Member -NotePropertyName type -NotePropertyValue $Type
        }
        if ($All.IsPresent) {
            $PermissionFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $PermissionFindObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_find/1"
            params  = @(@($Search),$PermissionFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionFindObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Find {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$Search,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$timelimit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [int]$sizelimit,
        [parameter(Mandatory=$false)]
            [switch]$Private,
        [parameter(Mandatory=$false)]
            [switch]$posix,
        [parameter(Mandatory=$false)]
            [switch]$nonposix,
        [parameter(Mandatory=$false)]
            [switch]$external,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Users,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NoUsers,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Groups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NoGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$InSudoRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInGroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInRoles,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInHBACRules,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$NotInSudoRules,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $GroupFindParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Private.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName private -NotePropertyValue $true
        }
        if ($posix.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName posix -NotePropertyValue $true
        }
        if ($nonposix.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName nonposix -NotePropertyValue $true
        }
        if ($external.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName external -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($sizelimit) {
            $GroupFindParams | Add-Member -NotePropertyName sizelimit -NotePropertyValue $sizelimit
        }
        if ($timelimit) {
            $GroupFindParams | Add-Member -NotePropertyName timelimit -NotePropertyValue $timelimit
        }
        if ($Users) {
            $GroupFindParams | Add-Member -NotePropertyName user -NotePropertyValue $Users
        }
        if ($NoUsers) {
            $GroupFindParams | Add-Member -NotePropertyName no_user -NotePropertyValue $NoUsers
        }
        if ($Groups) {
            $GroupFindParams | Add-Member -NotePropertyName group -NotePropertyValue $Groups
        }
        if ($NoGroups) {
            $GroupFindParams | Add-Member -NotePropertyName no_group -NotePropertyValue $NoGroups
        }
        if ($InGroups) {
            $GroupFindParams | Add-Member -NotePropertyName in_group -NotePropertyValue $InGroups
        }
        if ($InRoles) {
            $GroupFindParams | Add-Member -NotePropertyName in_role -NotePropertyValue $InRoles
        }
        if ($InHBACRules) {
            $GroupFindParams | Add-Member -NotePropertyName in_hbacrule -NotePropertyValue $InHBACRules
        }
        if ($InSudoRules) {
            $GroupFindParams | Add-Member -NotePropertyName in_sudorule -NotePropertyValue $InSudoRules
        }
        if ($NotInGroups) {
            $GroupFindParams | Add-Member -NotePropertyName not_in_group -NotePropertyValue $NotInGroups
        }
        if ($NotInRoles) {
            $GroupFindParams | Add-Member -NotePropertyName not_in_role -NotePropertyValue $NotInRoles
        }
        if ($NotInHBACRules) {
            $GroupFindParams | Add-Member -NotePropertyName not_in_hbacrule -NotePropertyValue $NotInHBACRules
        }
        if ($NotInSudoRules) {
            $GroupFindParams | Add-Member -NotePropertyName not_in_sudorule -NotePropertyValue $NotInSudoRules
        }
        if ($All.IsPresent) {
            $GroupFindParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $GroupFindObject = New-Object psobject -property @{
            id		= 0
            method	= "group_find/1"
            params  = @(@($Search),$GroupFindParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $GroupFindObject).result.result
        } else {
            Invoke-FreeIPAAPI $GroupFindObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Show {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $GroupShowParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $GroupShowParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $GroupShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $GroupShowParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $GroupShowParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $GroupShowObject = New-Object psobject -property @{
            id		= 0
            method	= "group_show/1"
            params  = @(@($cn),$GroupShowParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $GroupShowObject).result.result
        } else {
            Invoke-FreeIPAAPI $GroupShowObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Unlock {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserUnlockParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        $UserUnlockObject = New-Object psobject -property @{
            id		= 0
            method	= "user_unlock/1"
            params  = @(@($UID),$UserUnlockParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserUnlockObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserUnlockObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Enable {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserEnableParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        $UserEnableObject = New-Object psobject -property @{
            id		= 0
            method	= "user_enable/1"
            params  = @(@($UID),$UserEnableParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserEnableObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserEnableObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Disable {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserDisableParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        $UserDisableObject = New-Object psobject -property @{
            id		= 0
            method	= "user_disable/1"
            params  = @(@($UID),$UserDisableParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserDisableObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserDisableObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String[]]$UID,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue,
        [parameter(Mandatory=$false)]
            [switch]$Preserve
    )
    process {
        $UserDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $UserDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        if ($Preserve.IsPresent) {
            $UserDelParams | Add-Member -NotePropertyName preserve -NotePropertyValue $true
        }
        $UserDelObject = New-Object psobject -property @{
            id		= 0
            method	= "user_del/1"
            params  = @($UID,$UserDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserDelObject
        }
    }
}
Function Invoke-FreeIPAAPIHost_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String[]]$FQDN,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue,
        [parameter(Mandatory=$false)]
            [switch]$Preserve
    )
    process {
        $HostDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $HostDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        if ($Preserve.IsPresent) {
            $HostDelParams | Add-Member -NotePropertyName preserve -NotePropertyValue $true
        }
        $HostDelObject = New-Object psobject -property @{
            id		= 0
            method	= "host_del/1"
            params  = @($FQDN,$HostDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $HostDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $HostDelObject
        }
    }
}
Function Invoke-FreeIPAAPermission_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String[]]$cn,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue,
        [parameter(Mandatory=$false)]
            [switch]$Fore
    )
    process {
        $PermissionDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $PermissionDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        if ($force.IsPresent) {
            $PermissionDelParams | Add-Member -NotePropertyName force -NotePropertyValue $true
        }
        $PermissionDelObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_del/1"
            params  = @($cn,$PermissionDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionDelObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String[]]$cn,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue
    )
    process {
        $GroupDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $GroupDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        $GroupDelObject = New-Object psobject -property @{
            id		= 0
            method	= "group_del/1"
            params  = @($cn,$GroupDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $GroupDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $GroupDelObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String[]]$cn,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue
    )
    process {
        $RoleDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $RoleDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        $RoleDelObject = New-Object psobject -property @{
            id		= 0
            method	= "role_del/1"
            params  = @($cn,$RoleDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleDelObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Del {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String[]]$cn,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput,
        [parameter(Mandatory=$false)]
            [switch]$Continue
    )
    process {
        $PrivilegeDelParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($continue.IsPresent) {
            $PrivilegeDelParams | Add-Member -NotePropertyName continue -NotePropertyValue $true
        }
        $PrivilegeDelObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_del/1"
            params  = @($cn,$PrivilegeDelParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeDelObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeDelObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Add_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$users,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$groups,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserGroupAddMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $UserGroupAddMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $UserGroupAddMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($users) {
            $UserGroupAddMemberParams | Add-Member -NotePropertyName user -NotePropertyValue $users
        }
        if ($groups) {
            $UserGroupAddMemberParams | Add-Member -NotePropertyName group -NotePropertyValue $groups
        }
        $UserGroupAddMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "group_add_member/1"
            params  = @(@($cn),$UserGroupAddMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserGroupAddMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserGroupAddMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPermission_Add_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$privileges,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionAddMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionAddMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PermissionAddMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($privileges) {
            $PermissionAddMemberParams | Add-Member -NotePropertyName privilege -NotePropertyValue $privileges
        }
        $PermissionAddMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_add_member/1"
            params  = @(@($cn),$PermissionAddMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionAddMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionAddMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Add_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$roles,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeAddMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeAddMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PrivilegeAddMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($roles) {
            $PrivilegeAddMemberParams | Add-Member -NotePropertyName role -NotePropertyValue $roles
        }
        $PrivilegeAddMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_add_member/1"
            params  = @(@($cn),$PrivilegeAddMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeAddMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeAddMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Add_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Users,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Groups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Hosts,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Hostgroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Services,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {  
        $RoleAddMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $RoleAddMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $RoleAddMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Users) {
            $RoleAddMemberParams | Add-Member -NotePropertyName user -NotePropertyValue $Users
        }
        if ($Groups) {
            $RoleAddMemberParams | Add-Member -NotePropertyName group -NotePropertyValue $Groups
        }
        if ($Hosts) {
            $RoleAddMemberParams | Add-Member -NotePropertyName host -NotePropertyValue $Hosts
        }
        if ($Hostgroups) {
            $RoleAddMemberParams | Add-Member -NotePropertyName hostgroup -NotePropertyValue $Hostgroups
        }
        if ($Services) {
            $RoleAddMemberParams | Add-Member -NotePropertyName service -NotePropertyValue $Services
        }
        $RoleAddMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "role_add_member/1"
            params  = @(@($cn),$RoleAddMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleAddMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleAddMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Add_Permission {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$permissions,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeAddPermissionParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeAddPermissionParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PrivilegeAddPermissionParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($permissions) {
            $PrivilegeAddPermissionParams | Add-Member -NotePropertyName permission -NotePropertyValue $permissions
        }
        $PrivilegeAddPermissionObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_add_permission/1"
            params  = @(@($cn),$PrivilegeAddPermissionParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeAddPermissionObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeAddPermissionObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Add_Privilege {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Privileges,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleAddPrivilegeParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $RoleAddPrivilegeParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $RoleAddPrivilegeParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Privileges) {
            $RoleAddPrivilegeParams | Add-Member -NotePropertyName privilege -NotePropertyValue $privileges
        }
        $RoleAddPrivilegeObject = New-Object psobject -property @{
            id		= 0
            method	= "role_add_privilege/1"
            params  = @(@($cn),$RoleAddPrivilegeParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleAddPrivilegeObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleAddPrivilegeObject
        }
    } 
}
Function Invoke-FreeIPAAPIPermission_Add_Noaci {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$IPAPermissionType,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionAddNoaciParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionAddNoaciParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PermissionAddNoaciParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($IPAPermissionType) {
            $PermissionAddNoaciParams | Add-Member -NotePropertyName ipapermissiontype -NotePropertyValue $IPAPermissionType
        }
        $PermissionAddNoaciObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_add_noaci/1"
            params  = @(@($cn),$PermissionAddNoaciParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionAddNoaciObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionAddNoaciObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Remove_Privilege {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Privileges,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleRemovePrivilegeParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $RoleRemovePrivilegeParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $RoleRemovePrivilegeParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Privileges) {
            $RoleRemovePrivilegeParams | Add-Member -NotePropertyName privilege -NotePropertyValue $privileges
        }
        $RoleRemovePrivilegeObject = New-Object psobject -property @{
            id		= 0
            method	= "role_remove_privilege/1"
            params  = @(@($cn),$RoleRemovePrivilegeParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleRemovePrivilegeObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleRemovePrivilegeObject
        }
    } 
}
Function Invoke-FreeIPAAPIGroup_Remove_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$users,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$groups,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserGroupRemoveMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $UserGroupRemoveMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $UserGroupRemoveMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($users) {
            $UserGroupRemoveMemberParams | Add-Member -NotePropertyName user -NotePropertyValue $users
        }
        if ($groups) {
            $UserGroupRemoveMemberParams | Add-Member -NotePropertyName group -NotePropertyValue $groups
        }
        $UserGroupRemoveMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "group_remove_member/1"
            params  = @(@($cn),$UserGroupRemoveMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserGroupRemoveMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserGroupRemoveMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPermission_Remove_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$privileges,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionRemoveMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionRemoveMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PermissionRemoveMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($privileges) {
            $PermissionRemoveMemberParams | Add-Member -NotePropertyName privilege -NotePropertyValue $privileges
        }
        $PermissionRemoveMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_remove_member/1"
            params  = @(@($cn),$PermissionRemoveMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionRemoveMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionRemoveMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Remove_Permission {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$permissions,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeRemovePermissionParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeRemovePermissionParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PrivilegeRemovePermissionParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($permissions) {
            $PrivilegeRemovePermissionParams | Add-Member -NotePropertyName permission -NotePropertyValue $permissions
        }
        $PrivilegeRemovePermissionObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_remove_permission/1"
            params  = @(@($cn),$PrivilegeRemovePermissionParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeRemovePermissionObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeRemovePermissionObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Remove_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$roles,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeRemvoveMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeRemvoveMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $PrivilegeRemvoveMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($roles) {
            $PrivilegeRemvoveMemberParams | Add-Member -NotePropertyName role -NotePropertyValue $roles
        }
        $PrivilegeRemoveMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_remove_member/1"
            params  = @(@($cn),$PrivilegeRemvoveMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeRemoveMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeRemoveMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Remove_Member {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Users,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Groups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Hosts,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Hostgroups,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Services,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {  
        $RoleRemoveMemberParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Users) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName user -NotePropertyValue $Users
        }
        if ($Groups) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName group -NotePropertyValue $Groups
        }
        if ($Hosts) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName host -NotePropertyValue $Hosts
        }
        if ($Hostgroups) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName hostgroup -NotePropertyValue $Hostgroups
        }
        if ($Services) {
            $RoleRemoveMemberParams | Add-Member -NotePropertyName service -NotePropertyValue $Services
        }
        $RoleRemoveMemberObject = New-Object psobject -property @{
            id		= 0
            method	= "role_remove_member/1"
            params  = @(@($cn),$RoleRemoveMemberParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleRemoveMemberObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleRemoveMemberObject
        }
    }
}
Function Invoke-FreeIPAAPIPermission_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$CN,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidateSet("read", "search", "compare", "write", "add", "delete", "all")]
            [String[]]$Right,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Attrs,
        [parameter(Mandatory=$false)]
        [ValidateSet("permission", "all", "anonymous")]
            [String]$BindType,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Subtree,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Target,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetTo,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetFrom,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$RawFilter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$MemberOf,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$TargetGroup,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Type,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionModParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($Right) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermright -NotePropertyValue $Right
        }
        if ($Attrs) {
            $PermissionModParams | Add-Member -NotePropertyName attrs -NotePropertyValue $Attrs
        }
        if ($BindType) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermbindruletype -NotePropertyValue $BindType
        }
        if ($subtree) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermlocation -NotePropertyValue $subtree
        }
        if ($filter) {
            $PermissionModParams | Add-Member -NotePropertyName extratargetfilter -NotePropertyValue $filter
        }
        if ($rawfilter) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetfilter -NotePropertyValue $rawfilter
        }
        if ($Target) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtarget -NotePropertyValue $Target
        }
        if ($TargetTo) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetto -NotePropertyValue $TargetTo
        }
        if ($TargetFrom) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetfrom -NotePropertyValue $TargetFrom
        }
        if ($MemberOf) {
            $PermissionModParams | Add-Member -NotePropertyName memberof -NotePropertyValue $MemberOf
        }
        if ($targetgroup) {
            $PermissionFindParams | Add-Member -NotePropertyName targetgroup -NotePropertyValue $targetgroup
        }
        if ($Type) {
            $PermissionModParams | Add-Member -NotePropertyName type -NotePropertyValue $Type
        }
        if ($All.IsPresent) {
            $PermissionModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($AddAttr) {
            $PermissionModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $PermissionModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        $PermissionModObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_add/1"
            params  = @(@($CN),$PermissionModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionModObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionModObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$cn,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$nonposix,
        [parameter(Mandatory=$false)]
            [switch]$external,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserGroupAddParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
            description = $Desc
        }
        if ($NoMembers.IsPresent) {
            $UserGroupAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $UserGroupAddParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $UserGroupAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($nonposix.IsPresent) {
            $UserGroupAddParams | Add-Member -NotePropertyName nonposix -NotePropertyValue $true
        }
        if ($external.IsPresent) {
            $UserGroupAddParams | Add-Member -NotePropertyName external -NotePropertyValue $true
        }
        if ($AddAttr) {
            $UserGroupAddParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $UserGroupAddParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        $UserGroupAddObject = New-Object psobject -property @{
            id		= 0
            method	= "group_add/1"
            params  = @(@($cn),$UserGroupAddParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserGroupAddObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserGroupAddObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleAddParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Desc) {
            $RoleAddParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($AddAttr) {
            $RoleAddParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $RoleAddParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $RoleAddParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $RoleAddParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $RoleAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        $RoleAddObject = New-Object psobject -property @{
            id		= 0
            method	= "role_add/1"
            params  = @(@($cn),$RoleAddParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleAddObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleAddObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeAddParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Desc) {
            $PrivilegeAddParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($AddAttr) {
            $PrivilegeAddParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $PrivilegeAddParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $PrivilegeAddParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $PrivilegeAddParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $PrivilegeAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        $PrivilegeAddObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_add/1"
            params  = @(@($cn),$PrivilegeAddParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeAddObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeAddObject
        }
    }
}
Function Invoke-FreeIPAAPIHost_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$FQDN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Platform,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$OS,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Location,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Locality,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$IPAddress,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SSHPubkey,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Certificate,
        [parameter(Mandatory=$false)] 
        [ValidatePattern("^([a-fA-F0-9]{2}[:|\-]?){5}[a-fA-F0-9]{2}$")]
            [String[]]$MACAddress,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Class,
        [parameter(Mandatory=$false)] 
        [ValidateSet("otp","radius","password")]
            [String[]]$AuthInd,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)]
            [switch]$OKToAuthAsDelegate,
        [parameter(Mandatory=$false)]
            [switch]$OKAsDelegate,
        [parameter(Mandatory=$false)]
            [switch]$RequiresPreAuth,
        [parameter(Mandatory=$false)]
            [switch]$Force,
        [parameter(Mandatory=$false)]
            [switch]$NoReverse,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $HostAddParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
            random = $true
        }
        if ($Desc) {
            $HostAddParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($Platform) {
            $HostAddParams | Add-Member -NotePropertyName nshardwareplatform -NotePropertyValue $Platform
        }
        if ($OS) {
            $HostAddParams | Add-Member -NotePropertyName nsosversion -NotePropertyValue $OS
        }
        if ($Location) {
            $HostAddParams | Add-Member -NotePropertyName nshostlocation -NotePropertyValue $Location
        }
        if ($Locality) {
            $HostAddParams | Add-Member -NotePropertyName l -NotePropertyValue $Locality
        }
        if ($IPAddress) {
            $HostAddParams | Add-Member -NotePropertyName ip_address -NotePropertyValue $IPAddress
        }
        if ($SSHPubkey) {
            $HostAddParams | Add-Member -NotePropertyName ipasshpubkey -NotePropertyValue $SSHPubkey
        }
        if ($Certificate) {
            $HostAddParams | Add-Member -NotePropertyName usercertificate -NotePropertyValue $Certificate
        }
        if ($MACAddress) {
            $HostAddParams | Add-Member -NotePropertyName macaddress -NotePropertyValue $MACAddress
        }
        if ($Class) {
            $HostAddParams | Add-Member -NotePropertyName userclass -NotePropertyValue $Class
        }
        if ($AuthInd) {
            $HostAddParams | Add-Member -NotePropertyName krbprincipalauthind -NotePropertyValue $AuthInd
        }
        if ($AddAttr) {
            $HostAddParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($All.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($OKToAuthAsDelegate.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName ipakrboktoauthasdelegate -NotePropertyValue $true
        }
        if ($OKAsDelegate.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName ipakrbokasdelegate -NotePropertyValue $true
        }
        if ($RequiresPreAuth.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName ipakrbrequirespreauth -NotePropertyValue $true
        }
        if ($Force.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName force -NotePropertyValue $true
        }
        if ($NoReverse.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName no_reverse -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $HostAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        $HostAddObject = New-Object psobject -property @{
            id		= 0
            method	= "host_add/1"
            params  = @(@($FQDN),$HostAddParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $HostAddObject).result.result
        } else {
            Invoke-FreeIPAAPI $HostAddObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Add {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$")]
            [String]$UID,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$First,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Last,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Initials,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Title,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Orgunit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$City,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Shell,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Manager,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$employeenumber,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$employeetype,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^(([a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(;q\=((0(\.[0-9]{0,3})?)|(1(\.0{0,3})?)))?(\s*,\s*[a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(;q\=((0(\.[0-9]{0,3})?)|(1(\.0{0,3})?)))?)*)|(\*))$")]
            [String]$PreferredLanguage,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Class,
        [parameter(Mandatory=$false)] 
        [ValidateSet("otp","radius","password")]
            [String[]]$UserAuthType,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Email,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Phone,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Certificate,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SSHPubkey,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [System.DateTime]$PrincipalExpiration,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [System.DateTime]$PasswordExpiration,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Principal,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)]
            [switch]$NoPrivate,
        [parameter(Mandatory=$false)]
            [switch]$Disabled,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserAddParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
            random = $true
            givenname = $First
            sn = $Last
        }
        if ($preferredlanguage) {
            $UserAddParams | Add-Member -NotePropertyName preferredlanguage -NotePropertyValue $preferredlanguage
        }
        if ($Principal) {
            $UserAddParams | Add-Member -NotePropertyName krbprincipalname -NotePropertyValue $Principal
        }
        if ($PrincipalExpiration) {
            $UserAddParams | Add-Member -NotePropertyName krbprincipalexpiration -NotePropertyValue $PrincipalExpiration
        }
        if ($PasswordExpiration) {
            $UserAddParams | Add-Member -NotePropertyName krbpasswordexpiration -NotePropertyValue $PasswordExpiration
        }
        if ($Title) {
            $UserAddParams | Add-Member -NotePropertyName title -NotePropertyValue $Title
        }
        if ($employeenumber) {
            $UserAddParams | Add-Member -NotePropertyName employeenumber -NotePropertyValue $employeenumber
        }
        if ($employeetype) {
            $UserAddParams | Add-Member -NotePropertyName employeetype -NotePropertyValue $employeetype
        }
        if ($Manager) {
            $UserAddParams | Add-Member -NotePropertyName manager -NotePropertyValue $Manager
        }
        if ($Certificate) {
            $UserAddParams | Add-Member -NotePropertyName usercertificate -NotePropertyValue $Certificate
        }
        if ($Class) {
            $UserAddParams | Add-Member -NotePropertyName userclass -NotePropertyValue $Class
        }
        if ($AddAttr) {
            $UserAddParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($UserAuthType) {
            $UserAddParams | Add-Member -NotePropertyName ipauserauthtype -NotePropertyValue $UserAuthType
        }
        if ($SSHPubkey) {
            $UserAddParams | Add-Member -NotePropertyName ipasshpubkey -NotePropertyValue $SSHPubkey
        }
        if ($shell) {
            $UserAddParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $UserAddParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $UserAddParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($Disabled.IsPresent) {
            $UserAddParams | Add-Member -NotePropertyName nsaccountlock -NotePropertyValue $true
        }
        if ($NoPrivate.IsPresent) {
            $UserAddParams | Add-Member -NotePropertyName noprivate -NotePropertyValue $true
        }
        if ($phone) {
            $UserAddParams | Add-Member -NotePropertyName telephonenumber -NotePropertyValue $phone
        }
        if ($email) {
            $UserAddParams | Add-Member -NotePropertyName mail -NotePropertyValue $email
        }
        if ($city) {
            $UserAddParams | Add-Member -NotePropertyName l -NotePropertyValue $city
        }
        if ($orgunit) {
            $UserAddParams | Add-Member -NotePropertyName ou -NotePropertyValue $orgunit
        }
        if ($initials) {
            $UserAddParams | Add-Member -NotePropertyName initials -NotePropertyValue $initials
        }
        $UserAddObject = New-Object psobject -property @{
            id		= 0
            method	= "user_add/1"
            params  = @(@($UID),$UserAddParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserAddObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserAddObject
        }
    }
}
Function Invoke-FreeIPAAPIPermission_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[-_ a-zA-Z0-9.:/]+$"})]
            [String]$CN,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
        [ValidateSet("read", "search", "compare", "write", "add", "delete", "all")]
            [String[]]$Right,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Attrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$IncludedAttrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$ExcludedAttrs,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$DefaultAttrs,
        [parameter(Mandatory=$false)]
        [ValidateSet("permission", "all", "anonymous")]
            [String]$BindType,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Subtree,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$Target,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetTo,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^(?:(?<cn>CN|UID=(?<name>[^,]*)),)?(?:(?<path>(?:(?:CN|OU)=[^,]+,?)+),)?(?<domain>(?:DC=[^,]+,?)+)$"})]
            [String]$TargetFrom,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$Filter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$RawFilter,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String[]]$MemberOf,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$TargetGroup,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Type,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PermissionModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($NoMembers.IsPresent) {
            $PermissionModParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($Right) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermright -NotePropertyValue $Right
        }
        if ($Attrs) {
            $PermissionModParams | Add-Member -NotePropertyName attrs -NotePropertyValue $Attrs
        }
        if ($includedattrs) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermincludedattr -NotePropertyValue $includedattrs
        }
        if ($excludedattrs) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermexcludedattr -NotePropertyValue $excludedattrs
        }
        if ($DefaultAttrs) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermdefaultattr -NotePropertyValue $defaultattrs
        }
        if ($BindType) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermbindruletype -NotePropertyValue $BindType
        }
        if ($subtree) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermlocation -NotePropertyValue $subtree
        }
        if ($filter) {
            $PermissionModParams | Add-Member -NotePropertyName extratargetfilter -NotePropertyValue $filter
        }
        if ($rawfilter) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetfilter -NotePropertyValue $rawfilter
        }
        if ($Target) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtarget -NotePropertyValue $Target
        }
        if ($TargetTo) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetto -NotePropertyValue $TargetTo
        }
        if ($TargetFrom) {
            $PermissionModParams | Add-Member -NotePropertyName ipapermtargetfrom -NotePropertyValue $TargetFrom
        }
        if ($MemberOf) {
            $PermissionModParams | Add-Member -NotePropertyName memberof -NotePropertyValue $MemberOf
        }
        if ($targetgroup) {
            $PermissionFindParams | Add-Member -NotePropertyName targetgroup -NotePropertyValue $targetgroup
        }
        if ($Type) {
            $PermissionModParams | Add-Member -NotePropertyName type -NotePropertyValue $Type
        }
        if ($All.IsPresent) {
            $PermissionModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $PermissionModParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
            $PermissionModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($AddAttr) {
            $PermissionModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $PermissionModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        $PermissionModObject = New-Object psobject -property @{
            id		= 0
            method	= "permission_mod/1"
            params  = @(@($CN),$PermissionModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PermissionModObject).result.result
        } else {
            Invoke-FreeIPAAPI $PermissionModObject
        }
    }
}
Function Invoke-FreeIPAAPIHost_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$FQDN,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Platform,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$OS,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Location,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Locality,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$IPAddress,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SSHPubkey,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Certificate,
        [parameter(Mandatory=$false)] 
        [ValidatePattern("^([a-fA-F0-9]{2}[:|\-]?){5}[a-fA-F0-9]{2}$")]
            [String[]]$MACAddress,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Class,
        [parameter(Mandatory=$false)] 
        [ValidateSet("otp","radius","password")]
            [String[]]$AuthInd,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$OKToAuthAsDelegate,
        [parameter(Mandatory=$false)]
            [switch]$OKAsDelegate,
        [parameter(Mandatory=$false)]
            [switch]$RequiresPreAuth,
        [parameter(Mandatory=$false)]
            [switch]$Force,
        [parameter(Mandatory=$false)]
            [switch]$NoReverse,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $HostModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Desc) {
            $HostModParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($Platform) {
            $HostModParams | Add-Member -NotePropertyName nshardwareplatform -NotePropertyValue $Platform
        }
        if ($OS) {
            $HostModParams | Add-Member -NotePropertyName nsosversion -NotePropertyValue $OS
        }
        if ($Location) {
            $HostModParams | Add-Member -NotePropertyName nshostlocation -NotePropertyValue $Location
        }
        if ($Locality) {
            $HostModParams | Add-Member -NotePropertyName l -NotePropertyValue $Locality
        }
        if ($IPAddress) {
            $HostModParams | Add-Member -NotePropertyName ip_address -NotePropertyValue $IPAddress
        }
        if ($SSHPubkey) {
            $HostModParams | Add-Member -NotePropertyName ipasshpubkey -NotePropertyValue $SSHPubkey
        }
        if ($Certificate) {
            $HostModParams | Add-Member -NotePropertyName usercertificate -NotePropertyValue $Certificate
        }
        if ($MACAddress) {
            $HostModParams | Add-Member -NotePropertyName macaddress -NotePropertyValue $MACAddress
        }
        if ($Class) {
            $HostModParams | Add-Member -NotePropertyName userclass -NotePropertyValue $Class
        }
        if ($AuthInd) {
            $HostModParams | Add-Member -NotePropertyName krbprincipalauthind -NotePropertyValue $AuthInd
        }
        if ($AddAttr) {
            $HostModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $HostModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($Rights.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
            $HostModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($All.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Random.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName random -NotePropertyValue $true
        }
        if ($OKToAuthAsDelegate.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName ipakrboktoauthasdelegate -NotePropertyValue $true
        }
        if ($OKAsDelegate.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName ipakrbokasdelegate -NotePropertyValue $true
        }
        if ($RequiresPreAuth.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName ipakrbrequirespreauth -NotePropertyValue $true
        }
        if ($Force.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName force -NotePropertyValue $true
        }
        if ($NoReverse.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName no_reverse -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $HostModParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        $HostModObject = New-Object psobject -property @{
            id		= 0
            method	= "host_mod/1"
            params  = @(@($FQDN),$HostModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $HostModObject).result.result
        } else {
            Invoke-FreeIPAAPI $HostModObject
        }
    }
}
Function Invoke-FreeIPAAPIUser_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$")]
            [String]$UID,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$")]
            [String]$Rename,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$First,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Last,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Initials,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$Title,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Orgunit,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$City,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Shell,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Manager,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$employeenumber,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$employeetype,
        [parameter(Mandatory=$false)]
        [ValidatePattern("^(([a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(;q\=((0(\.[0-9]{0,3})?)|(1(\.0{0,3})?)))?(\s*,\s*[a-zA-Z]{1,8}(-[a-zA-Z]{1,8})?(;q\=((0(\.[0-9]{0,3})?)|(1(\.0{0,3})?)))?)*)|(\*))$")]
            [String]$PreferredLanguage,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [System.DateTime]$PrincipalExpiration,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [System.DateTime]$PasswordExpiration,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Principal,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Class,
        [parameter(Mandatory=$false)] 
        [ValidateSet("otp","radius","password")]
            [String[]]$UserAuthType,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Email,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Phone,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$Certificate,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SSHPubkey,        
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$Disabled,
        [parameter(Mandatory=$false)]
            [switch]$NoMembers,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Random,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $UserModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($PrincipalExpiration) {
            $UserModParams | Add-Member -NotePropertyName krbprincipalexpiration -NotePropertyValue $PrincipalExpiration
        }
        if ($PasswordExpiration) {
            $UserModParams | Add-Member -NotePropertyName krbpasswordexpiration -NotePropertyValue $PasswordExpiration
        }
        if ($Principal) {
            $UserModParams | Add-Member -NotePropertyName krbprincipalname -NotePropertyValue $Principal
        }
        if ($preferredlanguage) {
            $UserModParams | Add-Member -NotePropertyName preferredlanguage -NotePropertyValue $preferredlanguage
        }
        if ($Title) {
            $UserModParams | Add-Member -NotePropertyName title -NotePropertyValue $Title
        }
        if ($employeenumber) {
            $UserModParams | Add-Member -NotePropertyName employeenumber -NotePropertyValue $employeenumber
        }
        if ($employeetype) {
            $UserModParams | Add-Member -NotePropertyName employeetype -NotePropertyValue $employeetype
        }
        if ($Manager) {
            $UserModParams | Add-Member -NotePropertyName manager -NotePropertyValue $Manager
        }
        if ($Certificate) {
            $UserModParams | Add-Member -NotePropertyName usercertificate -NotePropertyValue $Certificate
        }
        if ($Class) {
            $UserModParams | Add-Member -NotePropertyName userclass -NotePropertyValue $Class
        }
        if ($UserAuthType) {
            $UserModParams | Add-Member -NotePropertyName ipauserauthtype -NotePropertyValue $UserAuthType
        }
        if ($SSHPubkey) {
            $UserModParams | Add-Member -NotePropertyName ipasshpubkey -NotePropertyValue $SSHPubkey
        }
        if ($Rename) {
            $UserModParams | Add-Member -NotePropertyName rename -NotePropertyValue $Rename
        }
        if ($First) {
            $UserModParams | Add-Member -NotePropertyName givenname -NotePropertyValue $First
        }
        if ($Last) {
            $UserModParams | Add-Member -NotePropertyName sn -NotePropertyValue $Last
        }
        if ($AddAttr) {
            $UserModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $UserModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $UserModParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $UserModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($random.IsPresent) {
            $UserModParams | Add-Member -NotePropertyName random -NotePropertyValue $true
        }
        if ($Disabled.IsPresent) {
            $UserModParams | Add-Member -NotePropertyName nsaccountlock -NotePropertyValue $true
        }
        if ($NoMembers.IsPresent) {
            $UserModParams | Add-Member -NotePropertyName no_members -NotePropertyValue $true
        }
        if ($phone) {
            $UserModParams | Add-Member -NotePropertyName telephonenumber -NotePropertyValue $phone
        }
        if ($email) {
            $UserModParams | Add-Member -NotePropertyName mail -NotePropertyValue $email
        }
        if ($city) {
            $UserModParams | Add-Member -NotePropertyName l -NotePropertyValue $city
        }
        if ($orgunit) {
            $UserModParams | Add-Member -NotePropertyName ou -NotePropertyValue $orgunit
        }
        if ($initials) {
            $UserModParams | Add-Member -NotePropertyName initials -NotePropertyValue $initials
        }
        $UserModObject = New-Object psobject -property @{
            id		= 0
            method	= "user_mod/1"
            params  = @(@($UID),$UserModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $UserModObject).result.result
        } else {
            Invoke-FreeIPAAPI $UserModObject
        }
    }
}
Function Invoke-FreeIPAAPIRole_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Rename,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $RoleModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Rename) {
            $RoleModParams | Add-Member -NotePropertyName rename -NotePropertyValue $Rename
        }
        if ($Desc) {
            $RoleModParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($AddAttr) {
            $RoleModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $RoleModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $RoleModParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $RoleModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($rights.IsPresent) {
            $RoleModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $RoleModParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $RoleModObject = New-Object psobject -property @{
            id		= 0
            method	= "role_mod/1"
            params  = @(@($cn),$RoleModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $RoleModObject).result.result
        } else {
            Invoke-FreeIPAAPI $RoleModObject
        }
    }
}
Function Invoke-FreeIPAAPIPrivilege_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
            [String]$Rename,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$rights,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $PrivilegeModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Rename) {
            $PrivilegeModParams | Add-Member -NotePropertyName rename -NotePropertyValue $Rename
        }
        if ($Desc) {
            $PrivilegeModParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($AddAttr) {
            $PrivilegeModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $PrivilegeModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $PrivilegeModParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $PrivilegeModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($rights.IsPresent) {
            $PrivilegeModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
            $PrivilegeModParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
        }
        $PrivilegeModObject = New-Object psobject -property @{
            id		= 0
            method	= "privilege_mod/1"
            params  = @(@($cn),$PrivilegeModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PrivilegeModObject).result.result
        } else {
            Invoke-FreeIPAAPI $PrivilegeModObject
        }
    }
}
Function Invoke-FreeIPAAPIGroup_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$cn,
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$Rename,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$Desc,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$external,
        [parameter(Mandatory=$false)]
            [switch]$posix,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $GroupModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($Rename) {
            $GroupModParams | Add-Member -NotePropertyName rename -NotePropertyValue $Rename
        }
        if ($Desc) {
            $GroupModParams | Add-Member -NotePropertyName description -NotePropertyValue $Desc
        }
        if ($AddAttr) {
            $GroupModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $GroupModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $GroupModParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $GroupModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($posix.IsPresent) {
            $GroupModParams | Add-Member -NotePropertyName posix -NotePropertyValue $true
        }
        if ($external.IsPresent) {
            $GroupModParams | Add-Member -NotePropertyName external -NotePropertyValue $true
        }
        $GroupModObject = New-Object psobject -property @{
            id		= 0
            method	= "group_mod/1"
            params  = @(@($cn),$GroupModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $GroupModObject).result.result
        } else {
            Invoke-FreeIPAAPI $GroupModObject
        }
    }
}
Function Invoke-FreeIPAAPIConfig_Mod {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [parameter(Mandatory=$false)]
        [ValidateScript({$_ -le 255})]
            [int]$MaxUserName,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$HomeDirectory,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$DefaultShell,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$DefaultGroup,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$EmailDomain,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [int]$SearchTimeLimit,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [int]$SearchRecordsLimit,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$UserSearch,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$GroupSearch,
        [parameter(Mandatory=$false)] 
        [ValidateScript({$_ -like "*$*"})]
            [String]$IpaSelinuxUserMapOrder,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$IpaSelinuxUserMapDefault,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$CARenewalMasterServer,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String]$DomainResolutionOrder,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$GroupObjectClasses,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$UserObjectClasses,
        [parameter(Mandatory=$false)] 
        [ValidateSet('AllowNThash','KDC:Disable Last Success','KDC:Disable Lockout','KDC:Disable Default Preauth for SPNs')]
            [String[]]$IpaConfigString,
        [parameter(Mandatory=$false)] 
        [ValidateSet('MS-PAC','PAD','nfs:NONE')]
            [String[]]$PacType,
        [parameter(Mandatory=$false)] 
        [ValidateSet('password','radius','otp','disabled')]
            [String[]]$UserAuthType,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$AddAttr,
        [parameter(Mandatory=$false)] 
        [ValidateNotNullOrEmpty()]
            [String[]]$SetAttr,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$Rights,
        [parameter(Mandatory=$false)]
            [switch]$EnableMigration,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $ConfigModParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($MaxUserName) {
            $ConfigModParams | Add-Member -NotePropertyName ipamaxusernamelength -NotePropertyValue $MaxUserName
        }
        if ($HomeDirectory) {
            $ConfigModParams | Add-Member -NotePropertyName ipahomesrootdir -NotePropertyValue $HomeDirectory
        }
        if ($DefaultShell) {
            $ConfigModParams | Add-Member -NotePropertyName ipadefaultloginshell -NotePropertyValue $DefaultShell
        }
        if ($DefaultGroup) {
            $ConfigModParams | Add-Member -NotePropertyName ipadefaultprimarygroup -NotePropertyValue $DefaultGroup
        }
        if ($EmailDomain) {
            $ConfigModParams | Add-Member -NotePropertyName ipadefaultemaildomain -NotePropertyValue $EmailDomain
        }
        if ($SearchTimeLimit) {
            $ConfigModParams | Add-Member -NotePropertyName ipasearchtimelimit -NotePropertyValue $SearchTimeLimit
        }
        if ($SearchRecordsLimit) {
            $ConfigModParams | Add-Member -NotePropertyName ipasearchrecordslimit -NotePropertyValue $SearchRecordsLimit
        }
        if ($UserSearch) {
            $ConfigModParams | Add-Member -NotePropertyName ipausersearchfields -NotePropertyValue $UserSearch
        }
        if ($GroupSearch) {
            $ConfigModParams | Add-Member -NotePropertyName ipagroupsearchfields -NotePropertyValue $GroupSearch
        }
        if ($IpaSelinuxUserMapOrder) {
            $ConfigModParams | Add-Member -NotePropertyName ipaselinuxusermaporder -NotePropertyValue $IpaSelinuxUserMapOrder
        }
        if ($IpaSelinuxUserMapDefault) {
            $ConfigModParams | Add-Member -NotePropertyName ipaselinuxusermapdefault -NotePropertyValue $IpaSelinuxUserMapDefault
        }
        if ($CARenewalMasterServer) {
            $ConfigModParams | Add-Member -NotePropertyName ca_renewal_master_server -NotePropertyValue $CARenewalMasterServer
        }
        if ($DomainResolutionOrder) {
            $ConfigModParams | Add-Member -NotePropertyName ipadomainresolutionorder -NotePropertyValue $DomainResolutionOrder
        }
        if ($GroupObjectClasses) {
            $ConfigModParams | Add-Member -NotePropertyName ipagroupobjectclasses -NotePropertyValue $GroupObjectClasses
        }
        if ($UserObjectClasses) {
            $ConfigModParams | Add-Member -NotePropertyName ipauserobjectclasses -NotePropertyValue $UserObjectClasses
        }
        if ($IpaConfigString) {
            $ConfigModParams | Add-Member -NotePropertyName ipaconfigstring -NotePropertyValue $IpaConfigString
        }
        if ($PacType) {
            $ConfigModParams | Add-Member -NotePropertyName ipakrbauthzdata -NotePropertyValue $PacType
        }
        if ($UserAuthType) {
            $ConfigModParams | Add-Member -NotePropertyName ipauserauthtype -NotePropertyValue $UserAuthType
        }
        if ($AddAttr) {
            $ConfigModParams | Add-Member -NotePropertyName addattr -NotePropertyValue $AddAttr
        }
        if ($SetAttr) {
            $ConfigModParams | Add-Member -NotePropertyName setattr -NotePropertyValue $SetAttr
        }
        if ($shell) {
            $ConfigModParams | Add-Member -NotePropertyName loginshell -NotePropertyValue $shell
        }
        if ($All.IsPresent) {
            $ConfigModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($Rights.IsPresent) {
            $ConfigModParams | Add-Member -NotePropertyName rights -NotePropertyValue $true
            $ConfigModParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        if ($EnableMigration.IsPresent) {
            $ConfigModParams | Add-Member -NotePropertyName ipamigrationenabled -NotePropertyValue $true
        }
        $ConfigModObject = New-Object psobject -property @{
            id		= 0
            method	= "config_mod/1"
            params  = @(@(),$ConfigModParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $ConfigModObject).result.result
        } else {
            Invoke-FreeIPAAPI $ConfigModObject
        }
    }
}
Function Invoke-FreeIPAAPIEnv {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $EnvParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($All.IsPresent) {
            $EnvParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $EnvObject = New-Object psobject -property @{
            id		= 0
            method	= "env/1"
            params  = @(@(),$EnvParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $EnvObject).result.result
        } else {
            Invoke-FreeIPAAPI $EnvObject
        }
    } 
}
Function Invoke-FreeIPAAPIPasswd {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [ValidateScript({$_ -match "^[a-zA-Z0-9_.][a-zA-Z0-9_.-]*[a-zA-Z0-9_.$-]?$"})]
            [String]$UID,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [SecureString]$CurrentPassword,
        [parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
            [SecureString]$NewPassword,
        [parameter(Mandatory=$false)]
            [switch]$All,
        [parameter(Mandatory=$false)]
            [switch]$FullResultsOutput
    )
    process {
        $SecureStringCurrentPassToBSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($CurrentPassword)
        $SecureStringNewPassToBSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword)
        $CurrentPasswordToBSTR = [Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringCurrentPassToBSTR)
        $NewPasswordToBSTR = [Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringNewPassToBSTR) 
        If (!$UID) {
            $UID = (Invoke-FreeIPAAPIUser_Find -Whoami -OnlyResultsOutput).uid
        }
        $PasswdParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        if ($All.IsPresent) {
            $PasswdParams | Add-Member -NotePropertyName all -NotePropertyValue $true
        }
        $PasswdObject = New-Object psobject -property @{
            id		= 0
            method	= "passwd/1"
            params  = @(@($UID,$NewPasswordToBSTR,$CurrentPasswordToBSTR),$PasswdParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $PasswdObject).result.result
        } else {
            Invoke-FreeIPAAPI $PasswdObject
        }
    }
}
Function Invoke-FreeIPAAPISessionLogout {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [parameter(Mandatory=$false)]
        [switch]$FullResultsOutput
    )
    process {
        $SessionLogoutParams = New-Object psobject -property @{
            version = $global:FreeIPAAPIServerConfig.ClientVersion
        }
        $SessionLogoutObject = New-Object psobject -property @{
            id		= 0
            method	= "session_logout/1"
            params  = @(@(),$SessionLogoutParams)
        }
        if (!($FullResultsOutput.IsPresent)) {
            (Invoke-FreeIPAAPI $SessionLogoutObject).result.result
        } else {
            Invoke-FreeIPAAPI $SessionLogoutObject
        }
    }
}
Function Invoke-FreeIPAAPI {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
            [Object]$inputAPIObject
    )
    begin {
        If (!(get-variable FreeIPASession)) {
            throw "Please use Get-FreeIPAAPIAuthenticationCookie function first to get an authentication cookie"
        }
    } process {
        try {
            $json = $inputAPIObject | ConvertTo-Json -Depth 3
            Write-Verbose -message $json
        } catch {
            write-error -message "Not able to convert input object to json"
            break
        }
        try {
            if ($json) {
                Invoke-RestMethod "$($global:FreeIPAAPIServerConfig.ServerURL)/ipa/session/json" -Method Post -WebSession $global:FreeIPASession -Body $json -ContentType 'application/json' -Headers @{"Referer"="$($global:FreeIPAAPIServerConfig.ServerURL)/ipa/session/json"}
            }            
        } catch [System.Net.Http.HttpRequestException] {
            switch ($_.Exception.Response.StatusCode.value__) {
                404 { 
                        Write-error -message "Please check that /ipa/session/json is available on your FreeIPA server"
                    }
                Default {
                            write-error -message "HTTP Error Code $($_.Exception.Response.StatusCode.Value__) with error message:$($_.Exception.Response.StatusDescription)"
                        }
            }
            Break
        } catch {
            write-error -message "error - please troubleshoot - error message:$($_.Exception.message)"
            break
        }
    }
}

New-alias -Name Get-IPAUser -Value Invoke-FreeIPAAPIUser_Show -Description "Get all info for an IPA User Account"
New-Alias -Name Show-IPAUser -value Invoke-FreeIPAAPIUser_Show -Description "Show all information available about an existing IPA user account"
New-Alias -Name Get-IPAUserStatus -Value Invoke-FreeIPAAPIUser_Status -Description "Get status of an IPA User Account"
New-Alias -Name Find-IPAUser -Value Invoke-FreeIPAAPIUser_Find -Description "Find IPA User Account"
New-Alias -Name New-IPAUser -value Invoke-FreeIPAAPIUser_Add -Description "Create new IPA User Account"
New-Alias -Name Set-IPAUser -Value Invoke-FreeIPAAPIUser_Mod -Description "Modify existing IPA User Account"
New-Alias -Name Enable-IPAUser -Value Invoke-FreeIPAAPIUser_Enable -Description "Enable an existing IPA User Account"
New-Alias -Name Disable-IPAUser -Value Invoke-FreeIPAAPIUser_Disable -Description "Disable an existing IPA User Account"
New-Alias -Name Unlock-IPAUser -Value Invoke-FreeIPAAPIUser_Unlock -Description "Unlock an existing locked IPA User Account"
New-Alias -Name Set-IPAUserPassword -Value Invoke-FreeIPAAPIPasswd -Description "set, change password for an IPA User Account"
New-Alias -Name Remove-IPAUser -Value Invoke-FreeIPAAPIUser_Del -Description "Remove existing IPA User Account"
New-alias -Name Show-IPAGroup -Value Invoke-FreeIPAAPIGroup_Show -Description "Get all info for an IPA Group"
New-alias -Name Get-IPAGroup -Value Invoke-FreeIPAAPIGroup_Show -Description "Get all info for an IPA Group"
New-Alias -Name Find-IPAGroup -Value Invoke-FreeIPAAPIGroup_Find -Description "Find IPA Group"
New-Alias -Name New-IPAGroup -value Invoke-FreeIPAAPIGroup_Add -Description "Create new IPA Group"
New-Alias -Name Set-IPAGroup -Value Invoke-FreeIPAAPIGroup_Mod -Description "Modify existing IPA Group"
New-Alias -Name Add-IPAGroupMember -value Invoke-FreeIPAAPIGroup_Add_Member -Description "Add member to existing IPA Group"
New-Alias -Name Remove-IPAGroupMember -value Invoke-FreeIPAAPIGroup_Remove_Member -Description "Remove member from existing IPA Group"
New-Alias -Name Remove-IPAGroup -Value Invoke-FreeIPAAPIGroup_Del -Description "Remove existing IPA Group"
New-Alias -Name Set-IPACredentials -value Set-FreeIPAAPICredentials -Description "Set your IPA API Credential for authentication purpose if your using non Kerberos authentication"
New-Alias -Name Import-IPACrendentials -Value Import-FreeIPAAPICrendentials -Description "Import your IPA API Credential from a local file hosted in your Windows Profile"
New-Alias -Name Set-IPAServerConfig -Value Set-FreeIPAAPIServerConfig -Description "Set IPA server URL and client version"
New-Alias -Name Connect-IPA -value Get-FreeIPAAPIAuthenticationCookie -Description "Get your authentication cookie and save it to be used with all cmdlets/functions"
New-Alias -Name Disconnect-IPA -value Invoke-FreeIPAAPISessionLogout -Description "Remove your authentication cookie and close remote server session"
New-Alias -Name Get-IPAConfig -value Invoke-FreeIPAAPIConfig_Show -Description "Get All IPA configuration information"
New-Alias -Name Get-IPAEnvironment -Value Invoke-FreeIPAAPIEnv -Description "Get all IPA environment information"
New-Alias -Name Set-IPAConfig -value Invoke-FreeIPAAPIConfig_Mod -Description "Set All IPA configuration"
New-Alias -Name Show-IPAPrivilege -value Invoke-FreeIPAAPIPrivilege_Show -Description "Show all information available about an existing IPA privilege"
New-Alias -Name Get-IPAPrivilege -value Invoke-FreeIPAAPIPrivilege_Show -Description "Show all information available about an existing IPA privilege"
New-Alias -Name Find-IPAPrivilege -value Invoke-FreeIPAAPIPrivilege_Find -Description "Find an IPA Privilege already set"
New-Alias -Name Set-IPAPrivilege -value Invoke-FreeIPAAPIPrivilege_Mod -Description "Modify an existing IPA Privilege"
New-Alias -Name New-IPAPrivilege -Value Invoke-FreeIPAAPIPrivilege_Add -Description "Create a new IPA Privilege"
New-Alias -Name Remove-IPAPrivilege -value Invoke-FreeIPAAPIPrivilege_Del -Description "Remove an existing IPA Privilege"
New-Alias -Name Show-IPAPermission -value Invoke-FreeIPAAPIPermission_Show -Description "Show all information available about an existing IPA Permission"
New-Alias -Name Get-IPAPermission -value Invoke-FreeIPAAPIPermission_Show -Description "Show all information available about an existing IPA Permission"
New-Alias -Name Find-IPAPermission -value Invoke-FreeIPAAPIPermission_Find -Description "Find an IPA Permission already set"
New-Alias -Name Set-IPAPermission -value Invoke-FreeIPAAPIPermission_Mod -Description "Modify an existing IPA Permission"
New-Alias -Name New-IPAPermission -Value Invoke-FreeIPAAPIPermission_Add -Description "Create a new IPA Permission"
New-Alias -Name Remove-IPAPermission -value Invoke-FreeIPAAPIPermission_Del -Description "Remove an existing IPA Permission"
New-Alias -Name Show-IPARole -value Invoke-FreeIPAAPIRole_Show -Description "Show all information available about an existing IPA Role"
New-Alias -Name Get-IPARole -value Invoke-FreeIPAAPIRole_Show -Description "Show all information available about an existing IPA Role"
New-Alias -Name Find-IPARole -value Invoke-FreeIPAAPIRole_Find -Description "Find an IPA Role already set"
New-Alias -Name Set-IPARole -value Invoke-FreeIPAAPIRole_Mod -Description "Modify an existing IPA Role"
New-Alias -Name New-IPARole -Value Invoke-FreeIPAAPIRole_Add -Description "Create a new IPA Role"
New-Alias -Name Remove-IPARole -value Invoke-FreeIPAAPIRole_Del -Description "Remove an existing IPA Role"
New-Alias -Name Add-IPAPermissionMember -value Invoke-FreeIPAAPIPermission_Add_Member -Description "Add a new member to an existing IPA Permission"
New-Alias -Name Remove-IPAPermissionMember -value Invoke-FreeIPAAPIPermission_Remove_Member -Description "Remove an existing member from an existing IPA Permission"
New-Alias -Name Add-IPAPrivilegeMember -Value Invoke-FreeIPAAPIPrivilege_Add_Member -Description "Add a new member to an existing IPA Privilege"
New-Alias -Name Remove-IPAPrivilegeMember -Value Invoke-FreeIPAAPIPrivilege_Remove_Member -Description "Remove an existing member from an existing IPA Privilege"
New-Alias -Name Add-IPARoleMember -Value Invoke-FreeIPAAPIRole_Add_Member -Description "Add a new member to an existing IPA Role"
New-Alias -Name Remove-IPARoleMember -value Invoke-FreeIPAAPIRole_Remove_Member -Description "Remove an existing member from an existing IPA Role"
New-Alias -Name New-IPANoACIPermission -value Invoke-FreeIPAAPIPermission_Add_Noaci -Description "Add a new IPA Permission without AI (internal command)"
New-Alias -Name Add-IPAPermissionPrivilege -Value Invoke-FreeIPAAPIPrivilege_Add_Permission -Description "Add permission to an existing IPA Privilege"
New-Alias -Name Remove-IPAPermissionPrivilege -Value Invoke-FreeIPAAPIPrivilege_Remove_Permission -Description "Remove permission to an existing IPA Privilege"
New-Alias -Name Add-PrivilegeRole -value Invoke-FreeIPAAPIRole_Add_Privilege -Description "Add Privilege to existing IPA Role"
New-Alias -Name Remove-PrivilegeRole -value Invoke-FreeIPAAPIRole_Remove_Privilege -Description "Remove Privilege to existing IPA Role"
New-Alias -Name New-IPAHost -value Invoke-FreeIPAAPIHost_Add -Description "Add a new IPA Host Object"
New-Alias -Name Set-IPAHost -value Invoke-FreeIPAAPIHost_Mod -Description "Modify an existing IPA Host Object"
New-Alias -Name Remove-IPAHost -value Invoke-FreeIPAAPIHost_Del -Description "Remove an existing IPA Host Object"
New-Alias -Name Show-IPAHost -value Invoke-FreeIPAAPIHost_Show -Description "Get all information FOR an existing IPA Host Object"
New-Alias -Name Get-IPAHost -value Invoke-FreeIPAAPIHost_Show -Description "Get all information FOR an existing IPA Host Object"
New-Alias -Name Find-IPAHost -Value Invoke-FreeIPAHost_Find -Description "Find an IPA Host Object"

Export-ModuleMember -Function Invoke-FreeIPAAPIPrivilege_Remove_Permission, Invoke-FreeIPAAPIPrivilege_Add_Permission, Invoke-FreeIPAAPIPermission_Add_Noaci, Invoke-FreeIPAAPIPermission_Add_Member, Invoke-FreeIPAAPIPermission_Remove_Member,Invoke-FreeIPAAPIPermission_Add, Invoke-FreeIPAAPPermission_Del, Invoke-FreeIPAAPIPermission_Mod, Invoke-FreeIPAAPIPermission_Find, Invoke-FreeIPAAPIPermission_Show, 
                                Invoke-FreeIPAAPIPrivilege_Show, Invoke-FreeIPAAPIPrivilege_Find, Invoke-FreeIPAAPIPrivilege_Mod, Invoke-FreeIPAAPIPrivilege_Add, Invoke-FreeIPAAPIPrivilege_Del, Invoke-FreeIPAAPIPrivilege_Add_Member, Invoke-FreeIPAAPIPrivilege_Remove_Member,
                                Invoke-FreeIPAAPIRole_Add_Privilege, Invoke-FreeIPAAPIRole_Remove_Privilege, Invoke-FreeIPAAPIRole_Show, Invoke-FreeIPAAPIRole_Find, Invoke-FreeIPAAPIRole_Mod, Invoke-FreeIPAAPIRole_Del, Invoke-FreeIPAAPIRole_Add, Invoke-FreeIPAAPIRole_Add_Member, Invoke-FreeIPAAPIRole_Remove_Member,
                                Invoke-FreeIPAAPIPasswd, Invoke-FreeIPAAPIEnv, 
                                Invoke-FreeIPAAPIUser_Find, Invoke-FreeIPAAPIUser_Status, Invoke-FreeIPAAPIUser_Add, Invoke-FreeIPAAPIUser_Del, Invoke-FreeIPAAPIUser_Mod, Invoke-FreeIPAAPIUser_Show, 
                                Invoke-FreeIPAAPIUser_Disable, Invoke-FreeIPAAPIUser_Enable, Invoke-FreeIPAAPIUser_Unlock, Show-IPAUser,
                                Invoke-FreeIPAAPIConfig_Show, Invoke-FreeIPAAPIConfig_Mod, 
                                Invoke-FreeIPAAPIGroup_Find, Invoke-FreeIPAAPIGroup_Mod, Invoke-FreeIPAAPIGroup_Remove_Member, Invoke-FreeIPAAPIGroup_Del, Invoke-FreeIPAAPIGroup_Show, Invoke-FreeIPAAPIGroup_Add, Invoke-FreeIPAAPIGroup_Add_Member, 
                                Invoke-FreeIPAAPI, 
                                Get-FreeIPAAPIAuthenticationCookie, Import-FreeIPAAPICrendentials, Set-FreeIPAAPICredentials, Import-FreeIPAAPICrendentials, Invoke-FreeIPAAPISessionLogout, Set-FreeIPAAPIServerConfig,
                                Invoke-FreeIPAAPIHost_Add, Invoke-FreeIPAAPIHost_Mod, Invoke-FreeIPAAPIHost_Del, Invoke-FreeIPAAPIHost_Show, Invoke-FreeIPAHost_Find

Export-ModuleMember -Alias Get-IPAUser, Get-IPAUserStatus, Find-IPAUser, New-IPAUser, Set-IPAUser, Remove-IPAUser, Show-IPAUser,
                            Enable-IPAUser, Disable-IPAUser, Unlock-IPAUser, Set-IPAUserPassword, 
                            Show-IPAGroup, Get-IPAGroup, Find-IPAGroup, New-IPAGroup, Set-IPAGroup, Add-IPAGroupMember, Remove-IPAGroupMember, Remove-IPAGroup, 
                            Set-IPACredentials, Import-IPACrendentials, Import-IPACrendentials, Set-IPAServerConfig, Import-IPACrendentials, Get-IPAAuthenticationCookie, Remove-IPAAuthenticationCookie, 
                            Get-IPAConfig, Get-IPAEnvironment, Set-IPAConfig, Connect-IPA, Disconnect-IPA,
                            Show-IPARole, Find-IPARole, Set-IPARole, New-IPARole, Remove-IPARole, Get-IPARole, Add-IPARoleMember, Remove-IPARoleMember,
                            Show-IPAPermission, Find-IPAPermission, Set-IPAPermission, New-IPAPermission, Remove-IPAPermission, Get-IPAPermission, Add-IPAPermissionMember, Remove-IPAPermissionMember,
                            Show-IPAPrivilege, Find-IPAPrivilege, Set-IPAPrivilege, New-IPAPrivilege, Remove-IPAPrivilege, Get-IPAPrivilege, Add-IPAPrivilegeMember, Remove-IPAPrivilegeMember,
                            Remove-PrivilegeRole, Add-PrivilegeRole, Remove-IPAPermissionPrivilege, Add-IPAPermissionPrivilege, New-IPANoACIPermission,
                            New-IPAHost, Set-IPAHost, Remove-IPAHost, Show-IPAHost, Get-IPAHost, Find-IPAHost