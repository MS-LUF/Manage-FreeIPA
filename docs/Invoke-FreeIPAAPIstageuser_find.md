---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIstageuser_find

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIstageuser_find [[-login] <String>] [[-first] <String>] [[-last] <String>] [[-cn] <String>]
 [[-displayname] <String>] [[-initials] <String>] [[-homedir] <String>] [[-gecos] <String>] [[-shell] <String>]
 [[-principal] <String[]>] [[-principal_expiration] <DateTime>] [[-password_expiration] <DateTime>]
 [[-email] <String[]>] [[-password] <SecureString>] [[-uid] <Int32>] [[-gidnumber] <Int32>]
 [[-street] <String>] [[-city] <String>] [[-state] <String>] [[-postalcode] <String>] [[-phone] <String[]>]
 [[-mobile] <String[]>] [[-pager] <String[]>] [[-fax] <String[]>] [[-orgunit] <String>] [[-title] <String>]
 [[-manager] <String>] [[-carlicense] <String[]>] [[-user_auth_type] <String[]>] [[-class] <String[]>]
 [[-radius] <String>] [[-radius_username] <String>] [[-departmentnumber] <String[]>]
 [[-employeenumber] <String>] [[-employeetype] <String>] [[-preferredlanguage] <String>]
 [[-certificate] <String[]>] [[-timelimit] <Int32>] [[-sizelimit] <Int32>] [-all] [-raw] [[-version] <String>]
 [-no_members] [-pkey_only] [[-in_groups] <String[]>] [[-not_in_groups] <String[]>]
 [[-in_netgroups] <String[]>] [[-not_in_netgroups] <String[]>] [[-in_roles] <String[]>]
 [[-not_in_roles] <String[]>] [[-in_hbacrules] <String[]>] [[-not_in_hbacrules] <String[]>]
 [[-in_sudorules] <String[]>] [[-not_in_sudorules] <String[]>] [[-criteria] <String>] [-FullResultsOutput]
 [<CommonParameters>]
```

## DESCRIPTION
Search for stage users.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -login
User login

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

### -first
First name

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

### -last
Last name

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

### -cn
Full name

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

### -displayname
Display name

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

### -initials
Initials

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

### -homedir
Home directory

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

### -gecos
GECOS

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

### -shell
Login shell

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

### -principal
Principal alias

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

### -principal_expiration
Kerberos principal expiration

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -password_expiration
User password expiration

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -email
Email address

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

### -password
Prompt to set the user password

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uid
User ID Number (system will assign one if not provided)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -gidnumber
Group ID Number

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -street
Street address

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -city
City

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -state
State/Province

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -postalcode
ZIP

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 20
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -phone
Telephone Number

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

### -mobile
Mobile Telephone Number

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

### -pager
Pager Number

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

### -fax
Fax Number

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

### -orgunit
Org.
Unit

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 25
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -title
Job Title

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 26
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -manager
Manager

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 27
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -carlicense
Car License

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

### -user_auth_type
Types of supported user authentication

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

### -class
User category (semantics placed on this attribute are for local interpretation)

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

### -radius
RADIUS proxy configuration

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

### -radius_username
RADIUS proxy username

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 32
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -departmentnumber
Department Number

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 33
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -employeenumber
Employee Number

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 34
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -employeetype
Employee Type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 35
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -preferredlanguage
Preferred Language

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 36
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -certificate
Base-64 encoded user certificate

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 37
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
Position: 38
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
Position: 39
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
Position: 40
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
Results should contain primary key attribute only ("login")

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

### -in_groups
Search for stage users with these member of groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 41
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_groups
Search for stage users without these member of groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 42
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_netgroups
Search for stage users with these member of netgroups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 43
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_netgroups
Search for stage users without these member of netgroups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 44
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_roles
Search for stage users with these member of roles.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 45
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_roles
Search for stage users without these member of roles.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 46
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_hbacrules
Search for stage users with these member of HBAC rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 47
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_hbacrules
Search for stage users without these member of HBAC rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 48
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -in_sudorules
Search for stage users with these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 49
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -not_in_sudorules
Search for stage users without these member of sudo rules.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 50
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
Position: 51
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
