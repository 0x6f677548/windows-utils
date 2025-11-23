# Get the directory to search from the command-line parameter
param (
    [string] $directory
)
# Description: Finds duplicate files in a directory and its subdirectories.
# Usage: Find-DuplicateFiles.ps1 -directory "C:\Users\user1\Documents"

# Get all files in the directory and its subdirectories
$files = Get-ChildItem $directory -Recurse | Where-Object { $_.PsIsContainer -eq $false }
$totalCount = $files.Count

# Set up the progress bar
$i = 0
$percentComplete = 0
Write-Progress -Activity "Searching for duplicate files..." -Status "Progress: $percentComplete% complete" -PercentComplete $percentComplete

# Group the files by their hash values
$groups = $files | Group-Object -Property { Get-FileHash $_.FullName }

# Loop through each group of files with matching hash values
foreach ($group in $groups) {
    # If there is more than one file with this hash value, they are duplicates
    if ($group.Count -gt 1) {
        # List the duplicate files
        Write-Output "Duplicate files (hash value $($group.Name)):"
        foreach ($file in $group.Group) {
            Write-Output "  $file"
        }
    }

    # Update the progress bar
    $i++
    $percentComplete = [int]($i / $totalCount * 100)
    $status = "Progress: $percentComplete% complete"
    Write-Progress -Activity "Searching for duplicate files..." -Status $status -PercentComplete $percentComplete
}

# Complete the progress bar
Write-Progress -Activity "Searching for duplicate files..." -Status "Search complete" -PercentComplete 100 -Completed
