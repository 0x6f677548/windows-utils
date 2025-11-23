#Lists client device dns configured addresses on connected devices, by interface metric order

$NetworkInterfaces  = Get-NetIPInterface | Where-Object ConnectionState -EQ 'Connected'
$DNSServerAddresses = Get-DnsClientServerAddress

$Combined = $NetworkInterfaces | ForEach-Object {
  [PSCustomObject]@{
    'InterfaceAlias'  = $_.InterfaceAlias
    'InterfaceIndex'  = $_.InterfaceIndex
    'InterfaceMetric' = $_.InterfaceMetric
    'DNSIPv4'         = ($DNSServerAddresses | Where-Object InterfaceIndex -EQ $_.InterfaceIndex | Where-Object AddressFamily -EQ 2).ServerAddresses
    'DNSIPv6'         = ($DNSServerAddresses | Where-Object InterfaceIndex -EQ $_.InterfaceIndex | Where-Object AddressFamily -EQ 23).ServerAddresses
  }
} | Sort-Object InterfaceMetric -Unique

$Combined | Format-Table -AutoSize