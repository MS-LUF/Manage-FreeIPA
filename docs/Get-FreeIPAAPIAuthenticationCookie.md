---
external help file: Manage-FreeIPA-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Get-FreeIPAAPIAuthenticationCookie

## SYNOPSIS
Get an authentication cookie from your IPA server in order to be able to use APIs

## SYNTAX

```
Get-FreeIPAAPIAuthenticationCookie [[-URL] <String>] [[-AdminLogin] <SecureString>]
 [[-AdminPassword] <SecureString>] [-UseCachedURLandCredentials] [-CloseAllRemoteSession] [<CommonParameters>]
```

## DESCRIPTION
Get a valid authentication cookie from your IPA server based on login/password authentication. 
The websession is saved to a global variable in order to be reused for API authentication.
You can import your credential from an encryoted file previously generated with Set-FreeIPAAPICrendentials and Set-FreeIPAAPIServerConfig cmdlets.

## EXAMPLES

### Example 1
```
PS C:\> Get-FreeIPAAPIAuthenticationCookie -UseCachedURLandCredentials
```

Connect to your FreeIPA server based on config / credential set with Set-FreeIPAAPICrendentials cmdlet

## PARAMETERS

### -AdminLogin
Your admin login

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminPassword
your admin password

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CloseAllRemoteSession
use this setting to close the remote session with your FreeIPA server

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
URL of your FreeIPA server.
https://myfreeipa.tld

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -UseCachedURLandCredentials
use this setting to import URL and credential from global variables $FreeIPAAPICredentials and $FreeIPAAPIServerConfig

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
