# DNS related scripts and snippets

This folder contains scripts and snippets related to DNS. Some of them are useful to test DNS servers, others are useful to manage DNS on Windows, like NRPT rules.
NRPT rules are useful to create DNS split tunnels, where you can have a DNS server for a specific domain, and another DNS server for all other domains. This is useful to have a DNS server for your home network, and another DNS server for the internet, like a Pi-Hole and Cloudflare DNS, respectively.
Windows is particularly tricky on the way it manages DNS on smart multi homed devices, like laptops. It will try to use all DNS servers configured on all interfaces, and will use the fastest one. This is not always the desired behavior, and NRPT rules can help with that. 

Smart multi-homed name resolution (SMHNR) is particularly worrying for privacy, as described in https://www.sans.org/white-papers/40165/ . As an example, even when using pi-hole, it is not always garanteed that the DNS queries will go through it, as Windows will try to use the fastest DNS server, and will use the fastest one, even if it is not the one configured on the interface. Some scripts here try to help with that, namely the ones to create NRPT rules. 


## PowerShell
### [Get-DnsOrder](Get-DnsOrder.ps1)
Lists client device dns configured addresses on connected devices, by interface metric order. 
Example
```
$ .\Get-DnsOrder.ps1


InterfaceAlias              InterfaceIndex InterfaceMetric DNSIPv4            DNSIPv6
--------------              -------------- --------------- -------            -------
wireguard-pihole                        54               5 {10.66.66.1}       {fd42:42:42::1}
Wi-Fi                                    6              30 {1.1.1.1, 1.0.0.1} {}
Loopback Pseudo-Interface 1              1              75 {}                 {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
```

### [Set-CloudFlareDns](Set-CloudFlareDns.ps1)
Sets the client dns of the $interface provided to Cloudflare dns

Example
```
$ .\Set-CloudFlareDns.ps1 -interface 6
```


### [Set-LocalhostDns](Set-LocalhostDns.ps1)
Sets the client dns of the $interface provided to localhost address. Useful when using dns-proxy.
It can also be a workaround to prevent dns leakage on windows on multi-homed devices, like when using a DNS split tunnel, although the best approach is to use NRPT tables (refer to https://www.sans.org/white-papers/40165/)  


Example
```
# .\Set-LocalhostDns.ps1 -interface 6
```


### [Replace-DefaultDnsNrptRule](Replace-DefaultDnsNrptRule.ps1)
Adds a NRPT rule with namespace '.' that points to provided $nameserver1 and $nameserver2. Useful to prevent dns leakage on Windows, namely with smart multi-homed name resolution (SMHNR). 
For detailed effects of SMHNR on privacy, refer to https://www.sans.org/white-papers/40165/

Steps:
    1) Removes all NRPT rules with . namespace
    2) Adds a NRPT rule with . namespace pointing to $nameserver1 and $nameserver2

Example

``` 
# setting DNS to the ipv4 and ipv6 of a split tunnel (like wireguard)
.\Replace-DefaultDnsClientNrptRule -nameserver1 '10.66.66.1' -nameserver2 'fd42:42:42::1'


# setting DNS to the ipv4 and ipv6 addresses of CloudFlare
.\Replace-DefaultDnsClientNrptRule -nameserver1 '1.1.1.1' -nameserver2 '2606:4700:4700::1111'

# setting DNS to the ipv4 addresses of CloudFlare
.\Replace-DefaultDnsClientNrptRule -nameserver1 '1.1.1.1' -nameserver2 '1.0.0.1'
```


### [Replace-DnsClientNrptRule](Replace-DnsClientNrptRule.ps1)
Replaces (if any) NRPT rule with namespace $namespace that points to provided $nameserver1 and $nameserver2
#Steps:
    1) Removes all NRPT rules with $namespace namespace
    2) Adds a NRPT rule with $namespace pointing to $nameserver1 and $nameserver2 (if provided)

Examples 
```
    .\Replace-DnsClientNrptRule -namespace '.' -displayname 'default' -nameserver1 '10.66.66.1' -nameserver2 'fd42:42:42::1'

    .\Replace-DnsClientNrptRule  -namespace '.' -displayname 'default' -nameserver1 '1.1.1.1' -nameserver2 '2606:4700:4700::1111'
    
    .\Replace-DnsClientNrptRule  -namespace '.' -displayname 'default' -nameserver1 '1.1.1.1' 

```
