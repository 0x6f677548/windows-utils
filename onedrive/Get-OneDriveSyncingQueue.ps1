#Lists files inside $directory being synched. Waits $wait millisencods
param ($directory, $wait)

Write-Host("Start Directory: '" + $directory + "'")


do {
    $syncing = 0;
    Get-ChildItem $directory -file -recurse | 
    Where-Object Attributes -eq 'Archive' | 
    ForEach-Object {
        Write-Host($_.Name + " : " + $_.Attributes)
        $syncing ++;
    }

    if ($syncing -gt 0)
    {
        Write-Host("Still syncing '" + $syncing + "' files.- Waiting '" + $wait + "' milliseconds to continue")
        Start-Sleep -Milliseconds $wait
               
    }

} while($syncing -gt 0)
