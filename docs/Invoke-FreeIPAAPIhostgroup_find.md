---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIhostgroup_find

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIhostgroup_find [[-hostgroup_name] <String>] [[-desc] <String>] [[-timelimit] <Int32>]
 [[-sizelimit] <Int32>] [-all] [-raw] [[-version] <String>] [-no_members] [-pkey_only] [[-hosts] <String[]>]
 [[-no_hosts] <String[]>] [[-hostgroups] <String[]>] [[-no_hostgroups] <String[]>]
 [[-in_hostgroups] <String[]>] [[-not_in_hostgroups] <String[]>] [[-in_netgroups] <String[]>]
 [[-not_in_netgroups] <String[]>] [[-in_hbacrules] <String[]>] [[-not_in_hbacrules] <String[]>]
 [[-in_sudorules] <String[]>] [[-not_in_sudorules] <String[]>] [[-membermanager_users] <String[]>]
 [[-not_membermanager_users] <String[]>] [[-membermanager_groups] <String[]>]
 [[-not_membermanager_groups] <String[]>] [[-criteria] <String>] [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
Search for hostgroups.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -hostgroup_name
Name of host-group

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

### -desc
A description of this host-group

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

### -timelimit
Time limit of search in seconds (0 is unlimited)

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

### -sizelimit
Maximum number of entries returned (0 is unlimited)

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
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -no_members
Suppress processing of membership attributes.

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

### -pkey_only
Results should contain primary key attribute only ("hostgroup-name")

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

### -hosts
Search for host groups with these member hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -no_hosts
Search for host groups without these member hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -hostgroups
Search for host groups with these member host groups.

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

### -no_hostgroups
Search for host groups without these member host groups.

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

### -in_hostgroups
Search for host groups with these member of host groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_hostgroups
Search for host groups without these member of host groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_netgroups
Search for host groups with these member of netgroups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_netgroups
Search for host groups without these member of netgroups.

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

### -in_hbacrules
Search for host groups with these member of HBAC rules.

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

### -not_in_hbacrules
Search for host groups without these member of HBAC rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_sudorules
Search for host groups with these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_sudorules
Search for host groups without these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -membermanager_users
Search for host groups with these group membership managed by users.

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

### -not_membermanager_users
Search for host groups without these group membership managed by users.

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

### -membermanager_groups
Search for host groups with these group membership managed by groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_membermanager_groups
Search for host groups without these group membership managed by groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -criteria
A string searched in all relevant object attributes

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullResultsOutput
{{ Fill FullResultsOutput Description }}

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

## OUTPUTS

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS
