#Lists files inside $directory being depromoted to online only inside a loop. Waits $wait millisencods
param ($directory, $wait)
Write-Host("Start Directory: '" + $directory + "'")


do {
    $syncing = 0;
    Get-ChildItem $directory -file -recurse | 
    Where-Object Attributes -eq 1049632 | 
    ForEach-Object {
        Write-Host($_.Name + " : " + $_.Attributes)
        $syncing ++;
    }

    if ($syncing -gt 0)
    {
        Write-Host("Still depromoting '" + $syncing + "' files.- Waiting '" + $wait + "' milliseconds to continue")
        Start-Sleep -Milliseconds $wait
               
    }

} while($syncing -gt 0)
Write-Host("Done.")
