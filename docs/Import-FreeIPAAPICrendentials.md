---
external help file: Manage-FreeIPA-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Import-FreeIPAAPICrendentials

## SYNOPSIS
Import from external config file, your previously saved credential to a global variable

## SYNTAX

```
Import-FreeIPAAPICrendentials [-MasterPassword] <SecureString> [<CommonParameters>]
```

## DESCRIPTION
Import your protected/ecrypted credential from %appdata%\Manage-FreeIPA\Manage-FreeIPA.xml (saved with Set-FreeIPAAPICredentials cmdlet) into $FreeIPAAPICredentials global variable.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-FreeIPAAPICrendentials -MasterPassword (ConvertTo-SecureString -String "keypass" -AsPlainText -Force)
```

Import your encrypted credential protected by keypass passphrase into $FreeIPAAPICredential

## PARAMETERS

### -MasterPassword
Master passowrd previously used to protect your external file.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Security.SecureString

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
