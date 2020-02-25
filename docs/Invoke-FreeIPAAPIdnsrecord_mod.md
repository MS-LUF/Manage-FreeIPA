---
external help file: manage-freeipa-help.xml
Module Name: Manage-FreeIPA
online version:
schema: 2.0.0
---

# Invoke-FreeIPAAPIdnsrecord_mod

## SYNOPSIS

## SYNTAX

```
Invoke-FreeIPAAPIdnsrecord_mod [[-ttl] <Int32>] [[-class] <String>] [[-a_rec] <String[]>]
 [[-a_ip_address] <String>] [[-aaaa_rec] <String[]>] [[-aaaa_ip_address] <String>] [[-a6_rec] <String[]>]
 [[-a6_data] <String>] [[-afsdb_rec] <String[]>] [[-afsdb_subtype] <Int32>] [[-afsdb_hostname] <String>]
 [[-apl_rec] <String[]>] [[-cert_rec] <String[]>] [[-cert_type] <Int32>] [[-cert_key_tag] <Int32>]
 [[-cert_algorithm] <Int32>] [[-cert_certificate_or_crl] <String>] [[-cname_rec] <String[]>]
 [[-cname_hostname] <String>] [[-dhcid_rec] <String[]>] [[-dlv_rec] <String[]>] [[-dlv_key_tag] <Int32>]
 [[-dlv_algorithm] <Int32>] [[-dlv_digest_type] <Int32>] [[-dlv_digest] <String>] [[-dname_rec] <String[]>]
 [[-dname_target] <String>] [[-ds_rec] <String[]>] [[-ds_key_tag] <Int32>] [[-ds_algorithm] <Int32>]
 [[-ds_digest_type] <Int32>] [[-ds_digest] <String>] [[-hip_rec] <String[]>] [[-ipseckey_rec] <String[]>]
 [[-key_rec] <String[]>] [[-kx_rec] <String[]>] [[-kx_preference] <Int32>] [[-kx_exchanger] <String>]
 [[-loc_rec] <String[]>] [[-loc_lat_deg] <Int32>] [[-loc_lat_min] <Int32>] [[-loc_lat_sec] <String>]
 [[-loc_lat_dir] <String>] [[-loc_lon_deg] <Int32>] [[-loc_lon_min] <Int32>] [[-loc_lon_sec] <String>]
 [[-loc_lon_dir] <String>] [[-loc_altitude] <String>] [[-loc_size] <String>] [[-loc_h_precision] <String>]
 [[-loc_v_precision] <String>] [[-mx_rec] <String[]>] [[-mx_preference] <Int32>] [[-mx_exchanger] <String>]
 [[-naptr_rec] <String[]>] [[-naptr_order] <Int32>] [[-naptr_preference] <Int32>] [[-naptr_flags] <String>]
 [[-naptr_service] <String>] [[-naptr_regexp] <String>] [[-naptr_replacement] <String>] [[-ns_rec] <String[]>]
 [[-ns_hostname] <String>] [[-nsec_rec] <String[]>] [[-ptr_rec] <String[]>] [[-ptr_hostname] <String>]
 [[-rrsig_rec] <String[]>] [[-rp_rec] <String[]>] [[-sig_rec] <String[]>] [[-spf_rec] <String[]>]
 [[-srv_rec] <String[]>] [[-srv_priority] <Int32>] [[-srv_weight] <Int32>] [[-srv_port] <Int32>]
 [[-srv_target] <String>] [[-sshfp_rec] <String[]>] [[-sshfp_algorithm] <Int32>] [[-sshfp_fp_type] <Int32>]
 [[-sshfp_fingerprint] <String>] [[-tlsa_rec] <String[]>] [[-tlsa_cert_usage] <Int32>]
 [[-tlsa_selector] <Int32>] [[-tlsa_matching_type] <Int32>] [[-tlsa_cert_association_data] <String>]
 [[-txt_rec] <String[]>] [[-txt_data] <String>] [[-uri_rec] <String[]>] [[-uri_priority] <Int32>]
 [[-uri_weight] <Int32>] [[-uri_target] <String>] [[-setattr] <String[]>] [[-addattr] <String[]>]
 [[-delattr] <String[]>] [-rights] [-structured] [-all] [-raw] [[-version] <String>] [[-rename] <String>]
 [-dnszone] <String> [-name] <String> [-FullResultsOutput] [<CommonParameters>]
```

## DESCRIPTION
Modify a DNS resource record.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ttl
Time to live

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -class
\<dnsclass\>

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

### -a_rec
Raw A records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -a_ip_address
A IP Address

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

### -aaaa_rec
Raw AAAA records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -aaaa_ip_address
AAAA IP Address

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

### -a6_rec
Raw A6 records

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

### -a6_data
A6 Record data

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

### -afsdb_rec
Raw AFSDB records

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

### -afsdb_subtype
AFSDB Subtype

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -afsdb_hostname
AFSDB Hostname

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

### -apl_rec
Raw APL records

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

### -cert_rec
Raw CERT records

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

### -cert_type
CERT Certificate Type

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -cert_key_tag
CERT Key Tag

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

### -cert_algorithm
CERT Algorithm

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

### -cert_certificate_or_crl
CERT Certificate/CRL

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

### -cname_rec
Raw CNAME records

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

### -cname_hostname
A hostname which this alias hostname points to

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

### -dhcid_rec
Raw DHCID records

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

### -dlv_rec
Raw DLV records

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

### -dlv_key_tag
DLV Key Tag

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 22
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -dlv_algorithm
DLV Algorithm

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 23
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -dlv_digest_type
DLV Digest Type

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 24
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -dlv_digest
DLV Digest

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

### -dname_rec
Raw DNAME records

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

### -dname_target
DNAME Target

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

### -ds_rec
Raw DS records

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

### -ds_key_tag
DS Key Tag

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 29
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ds_algorithm
DS Algorithm

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 30
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ds_digest_type
DS Digest Type

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 31
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ds_digest
DS Digest

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

### -hip_rec
Raw HIP records

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

### -ipseckey_rec
Raw IPSECKEY records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 34
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -key_rec
Raw KEY records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 35
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -kx_rec
Raw KX records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 36
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -kx_preference
Preference given to this exchanger.
Lower values are more preferred

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 37
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -kx_exchanger
A host willing to act as a key exchanger

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 38
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_rec
Raw LOC records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 39
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lat_deg
LOC Degrees Latitude

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 40
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lat_min
LOC Minutes Latitude

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 41
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lat_sec
LOC Seconds Latitude

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 42
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lat_dir
LOC Direction Latitude

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 43
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lon_deg
LOC Degrees Longitude

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 44
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lon_min
LOC Minutes Longitude

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 45
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lon_sec
LOC Seconds Longitude

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 46
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_lon_dir
LOC Direction Longitude

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 47
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_altitude
LOC Altitude

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 48
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_size
LOC Size

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 49
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_h_precision
LOC Horizontal Precision

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 50
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -loc_v_precision
LOC Vertical Precision

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

### -mx_rec
Raw MX records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 52
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -mx_preference
Preference given to this exchanger.
Lower values are more preferred

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 53
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -mx_exchanger
A host willing to act as a mail exchanger

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 54
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_rec
Raw NAPTR records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 55
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_order
NAPTR Order

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 56
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_preference
NAPTR Preference

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 57
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_flags
NAPTR Flags

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 58
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_service
NAPTR Service

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 59
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_regexp
NAPTR Regular Expression

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 60
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -naptr_replacement
NAPTR Replacement

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 61
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ns_rec
Raw NS records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 62
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ns_hostname
NS Hostname

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 63
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -nsec_rec
Raw NSEC records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 64
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ptr_rec
Raw PTR records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 65
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ptr_hostname
The hostname this reverse record points to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 66
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rrsig_rec
Raw RRSIG records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 67
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rp_rec
Raw RP records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 68
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sig_rec
Raw SIG records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 69
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -spf_rec
Raw SPF records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 70
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -srv_rec
Raw SRV records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 71
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -srv_priority
Lower number means higher priority.
Clients will attempt to contact the server with the lowest-numbered priority they can reach.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 72
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -srv_weight
Relative weight for entries with the same priority.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 73
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -srv_port
SRV Port

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 74
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -srv_target
The domain name of the target host or '.' if the service is decidedly not available at this domain

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 75
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshfp_rec
Raw SSHFP records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 76
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshfp_algorithm
SSHFP Algorithm

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 77
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshfp_fp_type
SSHFP Fingerprint Type

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 78
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -sshfp_fingerprint
SSHFP Fingerprint

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 79
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tlsa_rec
Raw TLSA records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 80
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -tlsa_cert_usage
TLSA Certificate Usage

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 81
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tlsa_selector
TLSA Selector

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 82
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tlsa_matching_type
TLSA Matching Type

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 83
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -tlsa_cert_association_data
TLSA Certificate Association Data

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 84
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -txt_rec
Raw TXT records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 85
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -txt_data
TXT Text Data

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 86
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_rec
Raw URI records

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 87
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_priority
Lower number means higher priority.
Clients will attempt to contact the URI with the lowest-numbered priority they can reach.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 88
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_weight
Relative weight for entries with the same priority.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 89
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -uri_target
Target Uniform Resource Identifier according to RFC 3986

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 90
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
Position: 91
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
Position: 92
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -delattr
Delete an attribute/value pair.
The option will be evaluated
last, after all sets and adds.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 93
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rights
Display the access rights of this entry (requires -all).
See ipa man page for details.

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

### -structured
Parse all raw DNS records and return them in a structured way

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
Position: 94
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -rename
Rename the DNS resource record object

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 95
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -dnszone
Zone name (FQDN)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 96
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -name
Record name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 97
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
