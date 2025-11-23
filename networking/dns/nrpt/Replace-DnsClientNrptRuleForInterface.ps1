#Replace-DnsClientNrptRuleForInterface
#Replaces (if any) NRPT rule for the namespace that corresponds to the provided interface 
# by assigning the DNS servers of the interface that has name provided
# This is useful, if, as an example, you have a default nrpt rule that is too wide, and you want to 
# replace it with a more specific rule that only applies to a specific  interface
# As an example, if you have a default rule that points to 1.1.1.1 and you have a vpn 
# you may want to add a new rule that points to the DNS servers of the interface that has that name

# Usage example:
# .\Replace-DnsClientNrptRuleForInterface.ps1 -name 'myvpn' -namespace '.example.local'
# this example will look for a network interface that has the name 'myvpn' and will
# replace the default rule with a new rule that points to the DNS servers of the interface that has the description 'example.local'
#

param (
    [parameter(Mandatory=$true)]
    [string]$name,
    [parameter(Mandatory=$true)]
    [string]$namespace
)


# Get network adapter information
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

# Initialize variables to store DNS servers
$dnsServer1 = $null
$dnsServer2 = $null

# Iterate through each adapter and check for the desired DNS suffix
foreach ($interface in $adapter) {
    Write-Host "Adapter: $($interface.Name)"
    # $interface | Format-List *
    
    if ($interface.Name -eq $name) {
        $dnsClient = Get-DnsClient -InterfaceIndex $interface.InterfaceIndex
        # Write-Host "DNS client for interface $($interface.Name):"
        # dump all properties of the dns client object
        # $dnsClient | Format-List *

        # Get the DNS servers for the interface
        $dnsConfig = Get-DnsClientServerAddress | Where-Object {$_.InterfaceIndex -eq $interface.InterfaceIndex}
        Write-Host "DNS servers for interface $($interface.Name): $($dnsConfig.ServerAddresses)"
        


        $dnsServer1 = $dnsConfig.ServerAddresses[0]
        if ($dnsConfig.ServerAddresses.Count -ge 2) {
            $dnsServer2 = $dnsConfig.ServerAddresses[1]
        }
        break
    }
}



# Set default value for optional parameter $nameserver2
if ($null -eq $dnsServer1) {
    $dnsServer1 = ''
}

# Call Replace-DnsClientNrptRule 
.\Replace-DnsClientNrptRule -namespace $namespace -displayname $name -nameserver1 $dnsServer1 -nameserver2 $dnsServer2