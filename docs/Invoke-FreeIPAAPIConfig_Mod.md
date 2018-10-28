---
external help file: Manage-FreeIPA-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIConfig_Mod

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Invoke-FreeIPAAPIConfig_Mod [[-MaxUserName] <Int32>] [[-HomeDirectory] <String>] [[-DefaultShell] <String>]
 [[-DefaultGroup] <String>] [[-EmailDomain] <String>] [[-SearchTimeLimit] <Int32>]
 [[-SearchRecordsLimit] <Int32>] [[-UserSearch] <String>] [[-GroupSearch] <String>]
 [[-IpaSelinuxUserMapOrder] <String>] [[-IpaSelinuxUserMapDefault] <String>]
 [[-CARenewalMasterServer] <String>] [[-DomainResolutionOrder] <String>] [[-GroupObjectClasses] <String[]>]
 [[-UserObjectClasses] <String[]>] [[-IpaConfigString] <String[]>] [[-PacType] <String[]>]
 [[-UserAuthType] <String[]>] [[-AddAttr] <String[]>] [[-SetAttr] <String[]>] [-All] [-Rights]
 [-EnableMigration] [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AddAttr
{{Fill AddAttr Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
{{Fill All Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CARenewalMasterServer
{{Fill CARenewalMasterServer Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultGroup
{{Fill DefaultGroup Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultShell
{{Fill DefaultShell Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainResolutionOrder
{{Fill DomainResolutionOrder Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EmailDomain
{{Fill EmailDomain Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableMigration
{{Fill EnableMigration Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupObjectClasses
{{Fill GroupObjectClasses Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupSearch
{{Fill GroupSearch Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HomeDirectory
{{Fill HomeDirectory Description}}

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

### -IpaConfigString
{{Fill IpaConfigString Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: AllowNThash, KDC:Disable Last Success, KDC:Disable Lockout, KDC:Disable Default Preauth for SPNs

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpaSelinuxUserMapDefault
{{Fill IpaSelinuxUserMapDefault Description}}

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

### -IpaSelinuxUserMapOrder
{{Fill IpaSelinuxUserMapOrder Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxUserName
{{Fill MaxUserName Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PacType
{{Fill PacType Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: MS-PAC, PAD, nfs:NONE

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rights
{{Fill Rights Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchRecordsLimit
{{Fill SearchRecordsLimit Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchTimeLimit
{{Fill SearchTimeLimit Description}}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetAttr
{{Fill SetAttr Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserAuthType
{{Fill UserAuthType Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: password, radius, otp, disabled

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserObjectClasses
{{Fill UserObjectClasses Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserSearch
{{Fill UserSearch Description}}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Management.Automation.PSObject

## NOTES

## RELATED LINKS
