#Moves the $numberOfFolders of child directories of $source to $destination, assuming that Destination is a Onedrive folder
#It waits that each directory syncs, before moving to the next one 
#this is usefull when moving large folders and to be used inside scheduled tasks or onedrive migrations
param ($source, $destination, $numberOfFolders, $wait)

Write-Host("Start Directory: '" + $source + "'")
Write-Host("Moving to: '" + $destination + "' the first '" + $numberOfFolders + "' directories")

$i = 0; 
Get-ChildItem $source -directory -recurse | 
    ForEach-Object {
        if ($i -lt $numberOfFolders) { 
            $dest = $destination + "\" + $_.Name;
            Write-Host($_.FullName + " -> " + $dest);
            Move-Item $_.FullName $dest
            $i++;

            do {
                $syncing = 0;
                Get-ChildItem $dest -file -recurse | 
                Where-Object Attributes -eq 'Archive' | 
                ForEach-Object {
                    $syncing ++;
                }

                if ($syncing -gt 0)
                {
                    Write-Host("Still syncing '" + $syncing + "' files.- Waiting '" + $wait + "' milliseconds to continue")
                    Start-Sleep -Milliseconds $wait;
                }

            } while($syncing -gt 0)
        }

    }
Write-Host("Done.")