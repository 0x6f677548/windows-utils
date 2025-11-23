param (
    [Parameter(Mandatory=$false)]
    [int]$days = 0
)
# Description: Delete Office logs and traces
# Usage: Delete-OfficeLogsAndTraces.ps1 -days 1


# Delete Office logs and traces from %TEMP%\Diagnostics
$path = "$env:TEMP\Diagnostics"
Write-Host "Deleting Office logs and traces from $path"

$folders = Get-ChildItem "$path" -Directory -Name | Where-Object { $_ -in "OUTLOOK", "EXCEL", "WINWORD", "POWERPNT", "ONENOTE", "ACCESS" }

foreach ($folder in $folders) {
    $fullPath = Join-Path "$path" $folder
    #calling the Delete-OldFiles.ps1 script
    .\Delete-OldFiles.ps1 -path $fullPath -attribute "LastAccessTime" -days $days
}

$fullPath = "$env:TEMP\Outlook Logging"
#check if folder exists
if ((Test-Path $fullPath)) {
    # Delete outlook logs and traces from %TEMP%\Outlook Logging
    #calling the Delete-OldFiles.ps1 script
    .\Delete-OldFiles.ps1 -path $fullPath -attribute "LastAccessTime" -days $days
}

