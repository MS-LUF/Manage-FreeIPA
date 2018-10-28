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
### Functions
- Get-FreeIPAAPIAuthenticationCookie                 
- Import-FreeIPAAPICrendentials                      
- Invoke-FreeIPAAPI                                  
- Invoke-FreeIPAAPIConfig_Mod                        
- Invoke-FreeIPAAPIConfig_Show                       
- Invoke-FreeIPAAPIEnv                               
- Invoke-FreeIPAAPIGroup_Add                         
- Invoke-FreeIPAAPIGroup_Add_Member                  
- Invoke-FreeIPAAPIGroup_Del                         
- Invoke-FreeIPAAPIGroup_Find                        
- Invoke-FreeIPAAPIGroup_Mod                         
- Invoke-FreeIPAAPIGroup_Remove_Member               
- Invoke-FreeIPAAPIGroup_Show                        
- Invoke-FreeIPAAPIHost_Add                          
- Invoke-FreeIPAAPIHost_Del                          
- Invoke-FreeIPAAPIHost_Mod                          
- Invoke-FreeIPAAPIHost_Show                         
- Invoke-FreeIPAAPIPasswd                            
- Invoke-FreeIPAAPIPermission_Add                    
- Invoke-FreeIPAAPIPermission_Add_Member             
- Invoke-FreeIPAAPIPermission_Add_Noaci              
- Invoke-FreeIPAAPIPermission_Find                   
- Invoke-FreeIPAAPIPermission_Mod                    
- Invoke-FreeIPAAPIPermission_Remove_Member          
- Invoke-FreeIPAAPIPermission_Show                   
- Invoke-FreeIPAAPIPrivilege_Add                     
- Invoke-FreeIPAAPIPrivilege_Add_Member              
- Invoke-FreeIPAAPIPrivilege_Add_Permission          
- Invoke-FreeIPAAPIPrivilege_Del                     
- Invoke-FreeIPAAPIPrivilege_Find                    
- Invoke-FreeIPAAPIPrivilege_Mod                     
- Invoke-FreeIPAAPIPrivilege_Remove_Member           
- Invoke-FreeIPAAPIPrivilege_Remove_Permission       
- Invoke-FreeIPAAPIPrivilege_Show                    
- Invoke-FreeIPAAPIRole_Add                          
- Invoke-FreeIPAAPIRole_Add_Member                   
- Invoke-FreeIPAAPIRole_Add_Privilege                
- Invoke-FreeIPAAPIRole_Del                          
- Invoke-FreeIPAAPIRole_Find                         
- Invoke-FreeIPAAPIRole_Mod                          
- Invoke-FreeIPAAPIRole_Remove_Member                
- Invoke-FreeIPAAPIRole_Remove_Privilege             
- Invoke-FreeIPAAPIRole_Show                         
- Invoke-FreeIPAAPISessionLogout                     
- Invoke-FreeIPAAPIUser_Add                          
- Invoke-FreeIPAAPIUser_Del                          
- Invoke-FreeIPAAPIUser_Disable                      
- Invoke-FreeIPAAPIUser_Enable                       
- Invoke-FreeIPAAPIUser_Find                         
- Invoke-FreeIPAAPIUser_Mod                          
- Invoke-FreeIPAAPIUser_Show                         
- Invoke-FreeIPAAPIUser_Status                       
- Invoke-FreeIPAAPIUser_Unlock                       
- Invoke-FreeIPAHost_Find                            
- Set-FreeIPAAPICredentials                          
- Set-FreeIPAAPIServerConfig                         
### Alias
- Add-IPAGroupMember                                 
- Add-IPAPermissionMember                            
- Add-IPAPermissionPrivilege                         
- Add-IPAPrivilegeMember                             
- Add-IPARoleMember                                  
- Add-PrivilegeRole                                  
- Connect-IPA                                        
- Disable-IPAUser                                    
- Disconnect-IPA                                     
- Enable-IPAUser                                     
- Find-IPAGroup                                      
- Find-IPAHost                                       
- Find-IPAPermission                                 
- Find-IPAPrivilege                                  
- Find-IPARole                                       
- Find-IPAUser                                       
- Get-IPAConfig                                      
- Get-IPAEnvironment                                 
- Get-IPAGroup                                       
- Get-IPAHost                                        
- Get-IPAPermission                                  
- Get-IPAPrivilege                                   
- Get-IPARole                                        
- Get-IPAUser                                        
- Get-IPAUserStatus                                  
- Import-IPACrendentials                             
- New-IPAGroup                                       
- New-IPAHost                                        
- New-IPANoACIPermission                             
- New-IPAPermission                                  
- New-IPAPrivilege                                   
- New-IPARole                                        
- New-IPAUser                                        
- Remove-IPAGroup                                    
- Remove-IPAGroupMember                              
- Remove-IPAHost                                     
- Remove-IPAPermission                               
- Remove-IPAPermissionMember                         
- Remove-IPAPermissionPrivilege                      
- Remove-IPAPrivilege                                
- Remove-IPAPrivilegeMember                          
- Remove-IPARole                                     
- Remove-IPARoleMember                               
- Remove-IPAUser                                     
- Remove-PrivilegeRole                               
- Set-IPAConfig                                      
- Set-IPACredentials                                 
- Set-IPAGroup                                       
- Set-IPAHost                                        
- Set-IPAPermission                                  
- Set-IPAPrivilege                                   
- Set-IPARole                                        
- Set-IPAServerConfig                                
- Set-IPAUser                                        
- Set-IPAUserPassword                                
- Show-IPAGroup                                      
- Show-IPAHost                                       
- Show-IPAPermission                                 
- Show-IPAPrivilege                                  
- Show-IPARole                                       
- Show-IPAUser                                       
- Unlock-IPAUser                                     

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
