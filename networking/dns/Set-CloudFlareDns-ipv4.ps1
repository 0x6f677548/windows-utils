#Sets the client dns of the $interface provided to Cloudflare dns
param ($interface)

$DNSAddresses = @(
  ([IPAddress]'1.1.1.1').IPAddressToString
  ([IPAddress]'1.0.0.1').IPAddressToString
)

Set-DnsClientServerAddress -ServerAddresses $DNSAddresses -InterfaceIndex $interface