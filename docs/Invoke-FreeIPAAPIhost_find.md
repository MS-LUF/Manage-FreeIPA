---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIhost_find

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIhost_find [[-hostname] <String>] [[-desc] <String>] [[-locality] <String>]
 [[-location] <String>] [[-platform] <String>] [[-os] <String>] [[-certificate] <String[]>]
 [[-macaddress] <String[]>] [[-class] <String[]>] [[-ipaassignedidview] <String>] [[-auth_ind] <String[]>]
 [[-timelimit] <Int32>] [[-sizelimit] <Int32>] [-all] [-raw] [[-version] <String>] [-no_members] [-pkey_only]
 [[-in_hostgroups] <String[]>] [[-not_in_hostgroups] <String[]>] [[-in_netgroups] <String[]>]
 [[-not_in_netgroups] <String[]>] [[-in_roles] <String[]>] [[-not_in_roles] <String[]>]
 [[-in_hbacrules] <String[]>] [[-not_in_hbacrules] <String[]>] [[-in_sudorules] <String[]>]
 [[-not_in_sudorules] <String[]>] [[-enroll_by_users] <String[]>] [[-not_enroll_by_users] <String[]>]
 [[-man_by_hosts] <String[]>] [[-not_man_by_hosts] <String[]>] [[-man_hosts] <String[]>]
 [[-not_man_hosts] <String[]>] [[-criteria] <String>] [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
Search for hosts.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -hostname
Host name

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
A description of this host

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

### -locality
Host locality (e.g.
"Baltimore, MD")

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

### -location
Host location (e.g.
"Lab 2")

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

### -platform
Host hardware platform (e.g.
"Lenovo T61")

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

### -os
Host operating system and version (e.g.
"Fedora 9")

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

### -certificate
Base-64 encoded host certificate

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

### -macaddress
Hardware MAC address(es) on this host

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

### -class
Host category (semantics placed on this attribute are for local interpretation)

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

### -ipaassignedidview
Assigned ID View

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

### -auth_ind
Defines a whitelist for Authentication Indicators.
Use 'otp' to allow OTP-based 2FA authentications.
Use 'radius' to allow RADIUS-based 2FA authentications.
Use 'pkinit' to allow PKINIT-based 2FA authentications.
Use 'hardened' to allow brute-force hardened password authentication by SPAKE or FAST.
With no indicator specified, all authentication mechanisms are allowed.

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

### -timelimit
Time limit of search in seconds (0 is unlimited)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
Position: 13
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
Position: 14
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
Results should contain primary key attribute only ("hostname")

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

### -in_hostgroups
Search for hosts with these member of host groups.

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

### -not_in_hostgroups
Search for hosts without these member of host groups.

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

### -in_netgroups
Search for hosts with these member of netgroups.

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

### -not_in_netgroups
Search for hosts without these member of netgroups.

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

### -in_roles
Search for hosts with these member of roles.

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

### -not_in_roles
Search for hosts without these member of roles.

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

### -in_hbacrules
Search for hosts with these member of HBAC rules.

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

### -not_in_hbacrules
Search for hosts without these member of HBAC rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_sudorules
Search for hosts with these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_sudorules
Search for hosts without these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -enroll_by_users
Search for hosts with these enrolled by users.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_enroll_by_users
Search for hosts without these enrolled by users.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -man_by_hosts
Search for hosts with these managed by hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_man_by_hosts
Search for hosts without these managed by hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 28
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -man_hosts
Search for hosts with these managing hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 29
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_man_hosts
Search for hosts without these managing hosts.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 30
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
Position: 31
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
