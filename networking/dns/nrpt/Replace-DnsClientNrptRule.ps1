#Replace-DnsClientNrptRule
#Replaces (if any) NRPT rule with namespace $namespace that points to provided $nameserver1 and $nameserver2
#Steps:
# 1) Removes all NRPT rules with $namespace namespace
# 2) Adds a NRPT rule with $namespace pointing to $nameserver1 and $nameserver2 (if provided)
#examples 
# .\Replace-DnsClientNrptRule -namespace '.' -displayname 'default' -nameserver1 '10.66.66.1' -nameserver2 'fd42:42:42::1'
# .\Replace-DnsClientNrptRule  -namespace '.' -displayname 'default' -nameserver1 '1.1.1.1' -nameserver2 '2606:4700:4700::1111'
# .\Replace-DnsClientNrptRule  -namespace '.' -displayname 'default' -nameserver1 '1.1.1.1' 

param (
    [parameter(Mandatory=$true)]
    [string]$namespace, 
    [parameter(Mandatory=$true)]
    [string]$displayname, 
    [parameter(Mandatory=$true)]
    [string]$nameserver1, 
    [string]$nameserver2
)

function Test-Param($param, $paramname) {
    if ($null -eq $param) {
        write-host "Missing parameter $paramname"
        exit
    }
}

#test if all mandatory parameters are provided
Test-Param $namespace -paramname 'namespace'
Test-Param $displayname -paramname 'displayname'
Test-Param $nameserver1 -paramname 'nameserver1'

if (![string]::IsNullOrEmpty($nameserver2)) {
    $DNSAddresses = @(
        ([IPAddress]$nameserver1).IPAddressToString
        ([IPAddress]$nameserver2).IPAddressToString
    )
}
else {
    $DNSAddresses = @(
        ([IPAddress]$nameserver1).IPAddressToString
    )
}

#prints all NRPT rules with $namespace namespace
Write-Host ("Rules to be deleted:")
Get-DnsClientNRptRule | Where-Object {$_.Namespace -eq $namespace }  | Format-Table displayName, nameSpace, nameServers


#clears all rules from the NRPT with the same namespace
Get-DnsClientNRptRule | Where-Object {$_.Namespace -eq $namespace} | Remove-DnsClientNrptRule -Force

Add-DnsClientNrptRule -Namespace $namespace -DisplayName $displayname -NameServers $DNSAddresses

Write-Host ("New rule created:")
Get-DnsClientNRptRule | Where-Object {$_.Namespace -eq $namespace}  | Format-Table displayName, nameSpace, nameServers
