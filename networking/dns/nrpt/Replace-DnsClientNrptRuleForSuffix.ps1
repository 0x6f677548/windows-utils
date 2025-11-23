#Replace-DnsClientNrptRuleForSuffix
#Replaces (if any) NRPT rule for the namespace that corresponds to the provided DNS suffix
# by assigning the DNS servers of the interface that has the DNS suffix
# This is useful, if, as an example, you have a default nrpt rule that is too wide, and you want to 
# replace it with a more specific rule that only applies to a specific DNS suffix and a specific interface
# As an example, if you have a default rule that points to 1.1.1.1 and you have a vpn that is for a specific DNS suffix
# you may want to add a new rule that points to the DNS servers of the interface that has the DNS suffix

# Additionally, a namespace can be provided as an optional parameter, if the namespace is not provided, the namespace will be the DNS suffix
# This is useful if you want to replace a rule that has a namespace that is different than the DNS suffix

# Usage example:
# .\Replace-DnsClientNrptRuleForSuffix.ps1 -dnsSuffix 'example.local'
# this example will look for a network interface that has the DNS suffix 'example.local' and will 
# replace the default rule with a new rule that points to the DNS servers of the interface that has the DNS suffix 'example.local'
#

param (
    [parameter(Mandatory=$true)]
    [string]$dnsSuffix,
    [parameter(Mandatory=$false)]
    [string]$namespace
)


# Get network adapter information
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "Up"}

# Initialize variables to store DNS servers
$dnsServer1 = $null
$dnsServer2 = $null

# Iterate through each adapter and check for the desired DNS suffix
foreach ($interface in $adapter) {
    Write-Host "Checking interface $($interface.Name) for DNS suffix $dnsSuffix"
    $dnsClient = Get-DnsClient -InterfaceIndex $interface.InterfaceIndex
    if ($dnsClient.ConnectionSpecificSuffix -eq $dnsSuffix) {
        Write-Host "Found DNS suffix $dnsSuffix on interface $($interface.Name)"

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

if (![string]::IsNullOrEmpty($namespace)) {
    $suffixNamespace = $namespace
}
else {
    $suffixNamespace = '.' + $dnsSuffix
}

# Call Replace-DnsClientNrptRule 
.\Replace-DnsClientNrptRule -namespace $suffixNamespace -displayname $dnsSuffix -nameserver1 $dnsServer1 -nameserver2 $dnsServer2