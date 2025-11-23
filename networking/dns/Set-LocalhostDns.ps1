#Set-LocalhostDns
#Sets the client dns of the $interface provided to localhost address. Useful when using dns-proxy
#It can also be a workaround to prevent dns leakage on windows on multi-homed devices, like when using 
# a DNS split tunnel, although the best approach is to use NRPT tables (refer to https://www.sans.org/white-papers/40165/)  
#examples
# .\Set-LocalhostDns.ps1 -interface 6
param ($interface)

$DNSAddresses = @(
  ([IPAddress]'127.0.0.1').IPAddressToString
  ([IPAddress]'::1').IPAddressToString
)

Set-DnsClientServerAddress -ServerAddresses $DNSAddresses -InterfaceIndex $interface