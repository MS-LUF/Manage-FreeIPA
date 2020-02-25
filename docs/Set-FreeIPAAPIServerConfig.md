---
external help file: Manage-FreeIPA-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Set-FreeIPAAPIServerConfig

## SYNOPSIS
Set your FreeIPA server URL and client version supported

## SYNTAX

```
Set-FreeIPAAPIServerConfig [[-URL] <String>] [[-ClientVersion] <String>] [<CommonParameters>]
```

## DESCRIPTION
Set your FreeIPA server URL and Client version supported.
If client version is not set, version 2.229 is set by default.
Warning : the CA (Certification authority) used by your FreeIPA server must be trusted on your system first.

## EXAMPLES

### Example 1
```
PS C:\> Set-FreeIPAAPIServerConfig -URL https://youripaserver.domain.tld
```

Set your FreeIPA server to youripaserver.domain.tld

## PARAMETERS

### -ClientVersion
Set your client version for API usage.
Version 2.229 is set by default

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -URL
Set your FreeIPA server URL : https://youripaserver.domain.tld

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
