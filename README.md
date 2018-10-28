# Manage-FreeIPA
Add few PowerShell cmdlets to manage a FreeIPA server through his JSONRPC web API - https://github.com/freeipa/freeipa

(c) 2018 lucas-cueff.com Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).

## Description
Manage-FreeIPA.psm1 PowerShell module provides a command line interface to manage your FreeIPA/IPA infrastructure from Powershell (Core/Classic - Windows/Linux/Mac Os).
Cmdlets and Alias respect the Powershell verb naming convention. All the parameters are based on the IPA Python cli embedded in the product.

## Functions, alias and naming convention
### Functions
The functions use the following naming convention : Invoke-FreeIPAAPI*APIName_APIAction*. For instance :
- API user_show, Powershell Cmdlet : Invoke-FreeIPAAPIUser_Show
### Alias
For each cmdlet function, a powershell alias is proposed with a "friendly" name :
- Powershell Cmdlet : Invoke-FreeIPAAPIUser_Show, Alias Get-IPAUser, Show-IPAUser
The idea of each alias is to be closed to classic cmdlet like Active Directory ones.

## Note
For more information on the FreeIPA API, please connect to the web interface on your IPA Server : https://yourIPA.domain.tld/ipa/ui/#/p/apibrowser/type=command
Don't forget to trust your IPA AC / ssl certificate locally before using the Powershell Module.

## Documentation
All docs are available in Mardown format under docs folder. Currently only my custom functions are fill, the other one are quite empty and will be filled soon.

## Install Manage-ADShadowGroup from PowerShell Gallery repository
You can easily install it from powershell gallery repository https://www.powershellgallery.com/packages/Manage-FreeIPA/ using a simple powershell command and an internet access :-)
```
	Install-Module -Name Manage-FreeIPA
```

## import module from PowerShell 
```
	C:\PS> import-module Manage-FreeIPA.psm1
```

## Exported Functions and Alias
###Functions
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Get-FreeIPAAPIAuthenticationCookie                 0.0        Manage-FreeIPA
Function        Import-FreeIPAAPICrendentials                      0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPI                                  0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIConfig_Mod                        0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIConfig_Show                       0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIEnv                               0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Add                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Add_Member                  0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Del                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Find                        0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Mod                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Remove_Member               0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIGroup_Show                        0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIHost_Add                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIHost_Del                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIHost_Mod                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIHost_Show                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPasswd                            0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Add                    0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Add_Member             0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Add_Noaci              0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Find                   0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Mod                    0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Remove_Member          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPermission_Show                   0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Add                     0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Add_Member              0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Add_Permission          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Del                     0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Find                    0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Mod                     0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Remove_Member           0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Remove_Permission       0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIPrivilege_Show                    0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Add                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Add_Member                   0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Add_Privilege                0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Del                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Find                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Mod                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Remove_Member                0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Remove_Privilege             0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIRole_Show                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPISessionLogout                     0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Add                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Del                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Disable                      0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Enable                       0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Find                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Mod                          0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Show                         0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Status                       0.0        Manage-FreeIPA
Function        Invoke-FreeIPAAPIUser_Unlock                       0.0        Manage-FreeIPA
Function        Invoke-FreeIPAHost_Find                            0.0        Manage-FreeIPA
Function        Set-FreeIPAAPICredentials                          0.0        Manage-FreeIPA
Function        Set-FreeIPAAPIServerConfig                         0.0        Manage-FreeIPA
### Alias
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           Add-IPAGroupMember                                 0.0        Manage-FreeIPA
Alias           Add-IPAPermissionMember                            0.0        Manage-FreeIPA
Alias           Add-IPAPermissionPrivilege                         0.0        Manage-FreeIPA
Alias           Add-IPAPrivilegeMember                             0.0        Manage-FreeIPA
Alias           Add-IPARoleMember                                  0.0        Manage-FreeIPA
Alias           Add-PrivilegeRole                                  0.0        Manage-FreeIPA
Alias           Connect-IPA                                        0.0        Manage-FreeIPA
Alias           Disable-IPAUser                                    0.0        Manage-FreeIPA
Alias           Disconnect-IPA                                     0.0        Manage-FreeIPA
Alias           Enable-IPAUser                                     0.0        Manage-FreeIPA
Alias           Find-IPAGroup                                      0.0        Manage-FreeIPA
Alias           Find-IPAHost                                       0.0        Manage-FreeIPA
Alias           Find-IPAPermission                                 0.0        Manage-FreeIPA
Alias           Find-IPAPrivilege                                  0.0        Manage-FreeIPA
Alias           Find-IPARole                                       0.0        Manage-FreeIPA
Alias           Find-IPAUser                                       0.0        Manage-FreeIPA
Alias           Get-IPAConfig                                      0.0        Manage-FreeIPA
Alias           Get-IPAEnvironment                                 0.0        Manage-FreeIPA
Alias           Get-IPAGroup                                       0.0        Manage-FreeIPA
Alias           Get-IPAHost                                        0.0        Manage-FreeIPA
Alias           Get-IPAPermission                                  0.0        Manage-FreeIPA
Alias           Get-IPAPrivilege                                   0.0        Manage-FreeIPA
Alias           Get-IPARole                                        0.0        Manage-FreeIPA
Alias           Get-IPAUser                                        0.0        Manage-FreeIPA
Alias           Get-IPAUserStatus                                  0.0        Manage-FreeIPA
Alias           Import-IPACrendentials                             0.0        Manage-FreeIPA
Alias           New-IPAGroup                                       0.0        Manage-FreeIPA
Alias           New-IPAHost                                        0.0        Manage-FreeIPA
Alias           New-IPANoACIPermission                             0.0        Manage-FreeIPA
Alias           New-IPAPermission                                  0.0        Manage-FreeIPA
Alias           New-IPAPrivilege                                   0.0        Manage-FreeIPA
Alias           New-IPARole                                        0.0        Manage-FreeIPA
Alias           New-IPAUser                                        0.0        Manage-FreeIPA
Alias           Remove-IPAGroup                                    0.0        Manage-FreeIPA
Alias           Remove-IPAGroupMember                              0.0        Manage-FreeIPA
Alias           Remove-IPAHost                                     0.0        Manage-FreeIPA
Alias           Remove-IPAPermission                               0.0        Manage-FreeIPA
Alias           Remove-IPAPermissionMember                         0.0        Manage-FreeIPA
Alias           Remove-IPAPermissionPrivilege                      0.0        Manage-FreeIPA
Alias           Remove-IPAPrivilege                                0.0        Manage-FreeIPA
Alias           Remove-IPAPrivilegeMember                          0.0        Manage-FreeIPA
Alias           Remove-IPARole                                     0.0        Manage-FreeIPA
Alias           Remove-IPARoleMember                               0.0        Manage-FreeIPA
Alias           Remove-IPAUser                                     0.0        Manage-FreeIPA
Alias           Remove-PrivilegeRole                               0.0        Manage-FreeIPA
Alias           Set-IPAConfig                                      0.0        Manage-FreeIPA
Alias           Set-IPACredentials                                 0.0        Manage-FreeIPA
Alias           Set-IPAGroup                                       0.0        Manage-FreeIPA
Alias           Set-IPAHost                                        0.0        Manage-FreeIPA
Alias           Set-IPAPermission                                  0.0        Manage-FreeIPA
Alias           Set-IPAPrivilege                                   0.0        Manage-FreeIPA
Alias           Set-IPARole                                        0.0        Manage-FreeIPA
Alias           Set-IPAServerConfig                                0.0        Manage-FreeIPA
Alias           Set-IPAUser                                        0.0        Manage-FreeIPA
Alias           Set-IPAUserPassword                                0.0        Manage-FreeIPA
Alias           Show-IPAGroup                                      0.0        Manage-FreeIPA
Alias           Show-IPAHost                                       0.0        Manage-FreeIPA
Alias           Show-IPAPermission                                 0.0        Manage-FreeIPA
Alias           Show-IPAPrivilege                                  0.0        Manage-FreeIPA
Alias           Show-IPARole                                       0.0        Manage-FreeIPA
Alias           Show-IPAUser                                       0.0        Manage-FreeIPA
Alias           Unlock-IPAUser                                     0.0        Manage-FreeIPA

## Use the module
### Set your config and be authenticated with your server
Set your encrypted credential in cache for future use and set it also in an external file if necessary (EncryptKeyInLocalFile and MasterPassword)
```
	C:\PS> Set-IPACredentials -AdminLogin (ConvertTo-SecureString -String "adminlogin" -AsPlainText -Force) -AdminPassword (ConvertTo-SecureString -String "adminpass" -AsPlainText -Force) -EncryptKeyInLocalFile -MasterPassword (ConvertTo-SecureString -String "Masterpass" -AsPlainText -Force)
```
Set your FreeIPA server URL info
```
	C:\PS> Set-IPAServerConfig -URL https://yourIPA.domain.tld
```
Get your authentication cookie to be authenticated with your APIs
```
	C:\PS> Connect-IPA -UseCachedURLandCredentials
```
Disconnect from the server
```
	C:\PS> Disconnect-IPA
```
### Example : Get info about objects
#### Users
Get all info available for myaccount
```
	C:\PS> Get-IPAUser -UID myaccount -All
```
#### Groups
Get all info available for myusergroup
```
	C:\PS> Get-IPAGroup -cn myusergroup -All 
```
