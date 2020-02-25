---
external help file: Manage-FreeIPA-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Set-FreeIPAAPICredentials

## SYNOPSIS
Set your FreeIPA Credential in cache (powershell global variable) or external file backup (encrypted)

## SYNTAX

```
Set-FreeIPAAPICredentials [-AdminLogin] <SecureString> [-AdminPassword] <SecureString> [-Remove]
 [-EncryptKeyInLocalFile] [-ConfigName <String>] [[-MasterPassword] <SecureString>] [<CommonParameters>]
```

## DESCRIPTION
Set your FreeIPA Credential in cache (powershell global variable) or external file backup (encrypted) To import your backed up credential use Import-FreeIPAAPICredentials cmdlet.
File hosted in %appdata%\Manage-FreeIPA\Manage-FreeIPA.xml

## EXAMPLES

### EXAMPLE 1
```
PS C:\Set-FreeIPAAPICredentials -AdminLogin (ConvertTo-SecureString -String "adminlogin" -AsPlainText -Force) -AdminPassword (ConvertTo-SecureString -String "adminpass" -AsPlainText -Force) -MasterPassword (ConvertTo-SecureString -String "keypass" -AsPlainText -Force) -EncryptKeyInLocalFile
```

Encrypt (password protected passphrase : keypass in example) and set your credentials (adminlogin/adminpass in example) as global variable and export it into a config file on local hard drive.

## PARAMETERS

### -AdminLogin
your admin login

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
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

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remove
Use this setting to remove the content of the current global variable.

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

### -EncryptKeyInLocalFile
Use this setting to export the credential in an external encrypted (password protected) file on local hard drive (%appdata%\Manage-FreeIPA\Manage-FreeIPA.xml)

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

### -MasterPassword
Master passowrd to protect your external file.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigName
{{ Fill ConfigName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
