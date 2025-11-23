# Description: Get active TCP connections and display public IP info for each connection
# uses ipwhois.app to get public IP info

$connections = Get-NetTCPConnection

# Group connections by process ID
$connectionsByProcess = $connections | Group-Object -Property OwningProcess

# Get details for each process
foreach ($connectionGroup in $connectionsByProcess) {
    $process = Get-Process -Id $connectionGroup.Name
    Write-Host "Process Name: $($process.ProcessName) (PID: $($process.Id))"
    Write-Host "Connections:"
    foreach ($connection in $connectionGroup.Group) {
        Write-Host "  $($connection.LocalAddress):$($connection.LocalPort) -> $($connection.RemoteAddress):$($connection.RemotePort) (Dest IP: $($connection.RemoteAddress))"


        # Try to resolve the destination IP address to a hostname
        $hostname = $null
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($connection.RemoteAddress).HostName
        } catch {
            # Ignore errors and continue
        }
        
        # Check if destination IP is a public address
        $publicIPInfo = $null
        if ($connection.RemoteAddress -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") {
            try {
                $publicIPInfo = Invoke-RestMethod "https://ipwhois.app/json/$($connection.RemoteAddress)"
            } catch {
                # Ignore errors and continue
            }
        }

        # Display public IP info if available
        if ($null -ne $publicIPInfo -and $publicIPInfo.success -and $publicIPInfo.isp -and $publicIPInfo.country) {            
            $infoStr = "    Public IP Info: $($publicIPInfo.isp) ($($publicIPInfo.country))"
            if ($hostname) {
                $infoStr += " (Hostname: $hostname)"
            }
            Write-Host $infoStr
        } elseif ($hostname) {
            Write-Host "    Hostname: $hostname"
        }
    }
}


# Get details for each process
foreach ($connectionGroup in $connectionsByProcess) {
    $process = Get-Process -Id $connectionGroup.Name
    Write-Host "Process Name: $($process.ProcessName) (PID: $($process.Id))"
    Write-Host "Connections:"
    foreach ($connection in $connectionGroup.Group) {
        Write-Host "  $($connection.LocalAddress):$($connection.LocalPort) -> $($connection.RemoteAddress):$($connection.RemotePort) (Dest IP: $($connection.RemoteAddress))"

        # Try to resolve the destination IP address to a hostname
        $hostname = $null
        try {
            $hostname = [System.Net.Dns]::GetHostEntry($connection.RemoteAddress).HostName
        } catch {
            # Ignore errors and continue
        }

        # Check if destination IP is a public address
        $publicIPInfo = $null
        if ($connection.RemoteAddress -match "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") {
            try {
                $publicIPInfo = Invoke-RestMethod "https://ipwhois.app/json/$($connection.RemoteAddress)"
            } catch {
                # Ignore errors and continue
            }
        }

        # Display public IP info if available
        if ($publicIPInfo) {
            $infoStr = "    Public IP Info: $($publicIPInfo.isp) ($($publicIPInfo.country))"
            if ($hostname) {
                $infoStr += " (Hostname: $hostname)"
            }
            Write-Host $infoStr
        } elseif ($hostname) {
            Write-Host "    Hostname: $hostname"
        }
    }
}
