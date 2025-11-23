#sets all files in $directory to online-only
param ($directory)

Write-Host("Start Directory: '" + $directory + "'")
Write-Host("Changing the following files to online only:")




get-childitem $directory -Force -File -Recurse |
Where-Object Attributes -eq 'Archive, ReparsePoint' |
ForEach-Object {
    Write-Host($_.FullName)
    attrib.exe $_.fullname +U -P /s
}