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
