---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIuser_unlock

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIuser_unlock [[-version] <String>] [-login] <String> [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
Unlock a user account

An account may become locked if the password is entered incorrectly too
many times within a specific time period as controlled by password
policy.
A locked account is a temporary condition and may be unlocked by
an administrator.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -version
Client version.
Used to determine if server will accept request.

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

### -login
User login

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullResultsOutput
{{Fill FullResultsOutput Description}}

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS