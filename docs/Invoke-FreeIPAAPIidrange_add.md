---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIidrange_add

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIidrange_add [-base_id] <Int32> [-range_size] <Int32> [[-rid_base] <Int32>]
 [[-secondary_rid_base] <Int32>] [[-dom_sid] <String>] [[-dom_name] <String>] [[-type] <String>]
 [[-setattr] <String[]>] [[-addattr] <String[]>] [-all] [-raw] [[-version] <String>] [-name] <String>
 [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
Add new ID range.

To add a new ID range you always have to specify

    -base-id
    -range-size

Additionally

    -rid-base
    -secondary-rid-base

may be given for a new ID range for the local domain while

    -rid-base
    -dom-sid

must be given to add a new range for a trusted AD domain.

=======
WARNING:

DNA plugin in 389-ds will allocate IDs based on the ranges configured for the
local domain.
Currently the DNA plugin *cannot* be reconfigured itself based
on the local ranges set via this family of commands.

Manual configuration change has to be done in the DNA plugin configuration for
the new local range.
Specifically, The dnaNextRange attribute of 'cn=Posix
IDs,cn=Distributed Numeric Assignment Plugin,cn=plugins,cn=config' has to be
modified to match the new range.
=======

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -base_id
First Posix ID of the range

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -range_size
Number of IDs in the range

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -rid_base
First RID of the corresponding RID range

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -secondary_rid_base
First RID of the secondary RID range

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -dom_sid
Domain SID of the trusted domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dom_name
Name of the trusted domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -type
ID range type, one of ipa-ad-trust, ipa-ad-trust-posix, ipa-local

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -setattr
Set an attribute to a name/value pair.
Format is attr=value.
For multi-valued attributes, the command replaces the values already present.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -addattr
Add an attribute/value pair.
Format is attr=value.
The attribute
must be part of the schema.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name
Range name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 11
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
