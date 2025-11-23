#Moves the $numberOfFolders of child directories of $source to $destination. 
#this is usefull when moving large folders and to be used inside scheduled tasks or onedrive migrations
param ($source, $destination, $numberOfFolders)

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
        }
    }
Write-Host("Done.")