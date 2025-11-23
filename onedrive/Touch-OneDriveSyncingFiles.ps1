#Touches a syncing file inside $directory. Sometimes this is usefull to unblock syncing files. 

param ($directory)
Write-Host("Start Directory: '" + $directory + "'")
Write-Host("Touching the following syncing files:")
Get-ChildItem $directory -file -recurse | 
    Where-Object Attributes -eq 1048608 |
    ForEach-Object {
        Write-Host($_.FullName)
        $_.LastWriteTime= (Get-Date)
    }
Write-Host("Done.")