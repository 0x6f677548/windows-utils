param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$InputFile

)
# Description: This script removes duplicate files by prompting the user to select which file to keep
# the input file is the output of finddupe https://github.com/jeremitu/finddupe
# Usage: Remove-Duplicates-finddupe.ps1 -InputFile "C:\Users\user1\Documents\finddupe.txt"


function Remove-DuplicateWithSuffix {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$file1,
        
        [Parameter(Mandatory=$true, Position=1)]
        [string]$file2,
        
        [Parameter(Mandatory=$true, Position=2)]
        [string]$Suffix,

        [Parameter(Mandatory=$false, Position=3)]
        [bool]$force = $false,

        [Parameter(Mandatory=$false, Position=4)]
        [bool]$recursive = $true
    )
    

    #check if the file2 is the same as the file1 but with the specified suffix as the last part of the file name
    if ($file1 -match "(.*)(?<=$Suffix)(\..*)") {

        #get the file name without the suffix, by removing the last part of the file name
        $suffixLength = $suffix.Length
        $file1WithoutSuffix = $Matches[1].Substring(0, $Matches[1].Length - $suffixLength) + $Matches[2]

        #get the file name without the directory
        $file1WithoutSuffix = Split-Path $file1WithoutSuffix -Leaf
        $file2WithoutDirectory = Split-Path $file2 -Leaf

        if ($file1WithoutSuffix -eq $file2WithoutDirectory -and (Get-Item $file1).Length -eq (Get-Item $file2).Length) {
            Write-Host "Removing $file1"

            if ($force) {
                Remove-Item $file1
            } else {
                #ask the user to confirm
                $choice = Read-Host "Enter Y to confirm, or any key to skip"
                if ($choice -eq "Y") {
                    Remove-Item $file1
                }
            }
            Write-Host ""
            return $true
        }
    } elseif ($recursive) {
        return Remove-DuplicateWithSuffix $file2 $file1 $Suffix $force $false
    }
    return $false
}



if ($PSBoundParameters.Count -eq 0) {
    Write-Host "Usage: Remove-Duplicate-finddupe -InputFile <input_file>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Description: This script removes duplicate files by prompting the user to select which file to keep."
    Write-Host ""
    Write-Host "Arguments:"
    Write-Host "  -InputFile  <input_file>   The path to the input file containing the list of duplicate files."
    Write-Host ""
    Write-Host "Example:"
    Write-Host "  Remove-Duplicate-finddupe -InputFile C:\Duplicates.txt "
    Write-Host ""
    Exit
}


#check if the input file exists
if (-not (Test-Path $InputFile -PathType Leaf)) {
    Write-Warning "Input file not found: $InputFile"
    Exit
}

# Open the input and output files
$inFile = Get-Content $InputFile



# Loop over the input file
for ($i = 0; $i -lt $inFile.Count; $i += 2) {

    #check if line starts with "Duplicate: '" and get the file name. use the regex match operator to get the file name
    # 

    $dupFile = ""
    $withFile = ""
    if ($inFile[$i] -match "(?<=Duplicate: ')(.*?)(?=')") {
        $dupFile = $Matches[1]
    } else {
        Write-Warning "Cannot find the first file name in line $($i+1). Skipping this pair of files."
        continue
    }

    if ($inFile[$i+1] -match "(?<=With:      ')(.*?)(?=')") {
        $withFile = $Matches[1]
    } else {
        Write-Host $inFile[$i+1]
        Write-Warning "Cannot find the second file name in line $($i+2). Skipping this pair of files."
        continue
    }

    #check if the files exist
    if (-not (Test-Path $dupFile -PathType Leaf)) {
        Write-Warning "File not found: $dupFile"
        continue
    }
    if (-not (Test-Path $withFile -PathType Leaf)) {
        Write-Warning "File not found: $withFile"
        continue
    }

    #generate a string with file size and file modified date
    $dupFileStats = Get-Item $dupFile | Select-Object Length, LastWriteTime
    $withFileStats = Get-Item $withFile | Select-Object Length, LastWriteTime


    # Print the two files to the user and ask which one to keep

    Write-Host "1) : $dupFile (Size: $($dupFileStats.Length), Modified: $($dupFileStats.LastWriteTime) )"
    Write-Host "2) : $withFile (Size: $($withFileStats.Length), Modified: $($withFileStats.LastWriteTime) )"


    #check if the withFile is the same as the dupFile but with "_highres" as the last part of the file name
    if (Remove-DuplicateWithSuffix $dupFile $withFile "__highres" $true ) {
        continue
    }

    #check if the withFile is the same as the dupFile but with " 1" as the last part of the file name
    if (Remove-DuplicateWithSuffix $dupFile $withFile " 1" $true) {
        continue
    }

    #check if the withFile is the same as the dupFile but with " 1" as the last part of the file name
    if (Remove-DuplicateWithSuffix $dupFile $withFile " 2" $true) {
        continue
    }



    #if the file size is different, warn the user
    if ($dupFileStats.Length -ne $withFileStats.Length) {
        Write-Warning "File size is different. Please check the files carefully."
    }

    $choice = Read-Host "Enter 1 to keep file 1, 2 to keep file 2, or any key to decide later"
    if ($choice -eq "1") {
        Remove-Item $withFile
    }
    elseif ($choice -eq "2") {
        Remove-Item $dupFile
    }
    Write-Host ""
}
