# Get the source and search directories from the command-line parameters
param (
    [string] $sourceDir,
    [string] $searchDir
)
# Description: Finds files in the source directory that are not in the search directory.
#           This script is useful for finding files that were not copied to a destination directory.
# Usage: Find-FilesNotInDirectory.ps1 -sourceDir "C:\Users\user1\Documents" -searchDir "C:\Users\user2\Documents"

# Get the source and search directories from the command-line parameters
$files = Get-ChildItem $sourceDir -Recurse | Where-Object { $_.PsIsContainer -eq $false }

# Set up the progress bar
$totalCount = $files.Count
$i = 0
$percentComplete = 0
Write-Progress -Activity "Searching files..." -Status "Progress: $percentComplete % complete" -PercentComplete $percentComplete

# Loop through each file in the source directory
foreach ($file in $files) {
    # Get the relative path of the file
    $relativePath = $file.FullName.Substring($sourceDir.Length + 1)

    # Search for the file in the search directory
    $searchResults = Get-ChildItem $searchDir -Recurse -Filter $file.Name | Where-Object { $_.PsIsContainer -eq $false }

    # If the file is not found in the search directory, list it
    if ($searchResults.Count -eq 0) {
        Write-Output "File not found: $relativePath"
    }

    # Update the progress bar
    $i++
    $percentComplete = [int]($i / $totalCount * 100)
    $status = "Progress: $percentComplete% complete | File $i of $totalCount : $relativePath"
    Write-Progress -Activity "Searching files..." -Status $status -PercentComplete $percentComplete
}

# Complete the progress bar
Write-Progress -Activity "Searching files..." -Status "Search complete" -PercentComplete 100 -Completed
