param(
    [Parameter(Mandatory=$false)]
    [string]$path = "$env:TEMP",
    [Parameter(Mandatory=$false)]
    [string]$attribute = "LastAccessTime",
    [Parameter(Mandatory=$false)]
    [int]$days = 7
)

# Description: Delete files older than $days days in a specified directory
# the attribute can be LastAccessTime, LastWriteTime or CreationTime
# Default values are $env:TEMP, LastAccessTime and 7 days
# arguments can be passed as parameters
# Example: Delete-OldFiles.ps1 -path "C:\example" -attribute "LastAccessTime" -days 7

$limit = (Get-Date).AddDays(-$days)

Write-Host "Deleting files older than $days days in $path based on $attribute :"

$filesToDelete = Get-ChildItem -Path $path -Recurse | Where-Object { $_.$attribute -lt $limit -and !$_.PSIsContainer }
$filesToDelete | Select-Object -Property FullName, $attribute
$filesToDelete | Remove-Item -Force
