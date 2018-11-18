---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIuser_status

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIuser_status [-all] [-raw] [[-version] <String>] [-login] <String> [-FullResultsOutput]
 [<CommonParameters>]
```

## DESCRIPTION
Lockout status of a user account

An account may become locked if the password is entered incorrectly too
many times within a specific time period as controlled by password
policy.
A locked account is a temporary condition and may be unlocked by
an administrator.

This connects to each IPA master and displays the lockout status on
each one.

To determine whether an account is locked on a given server you need
to compare the number of failed logins and the time of the last failure.
For an account to be locked it must exceed the maxfail failures within
the failinterval duration as specified in the password policy associated
with the user.

The failed login counter is modified only when a user attempts a log in
so it is possible that an account may appear locked but the last failed
login attempt is older than the lockouttime of the password policy.
This
means that the user may attempt a login again.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -all
Retrieve and print all attributes from the server.
Affects command output.

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

### -raw
Print entries as stored on the server.
Only affects output format.

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
