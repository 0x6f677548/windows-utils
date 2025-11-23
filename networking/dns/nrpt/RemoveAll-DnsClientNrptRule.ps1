#RemoveAll-DnsClientNrptRule
#Removes all NRPT rules
#Steps:
# 1) Prints all NRPT rules
# 2) Asks for confirmation
# 3) Removes all NRPT rules
#examples
# .\RemoveAll-DnsClientNrptRule




# Prints all NRPT rules
Write-Host ("Rules to be deleted:")
Get-DnsClientNRptRule | Format-Table displayName, nameSpace, nameServers


#ask the user to confirm the action
write-host "This will remove all DNS Client NRPT rules from the local machine. Are you sure you want to continue? (y/n)"
$answer = read-host
if ($answer -ne "y") {
    write-host "Aborting"
    exit
}

#clears all rules from the NRPT with the same namespace
Get-DnsClientNRptRule | Remove-DnsClientNrptRule -Force