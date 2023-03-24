function Get-FileMD5($filePath) {
    $md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $bytes = [System.IO.File]::ReadAllBytes($filePath)
    $hashBytes = $md5.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hashBytes) -replace '-', ''
}

function Write-Percentage($percent) {
    Write-Host -NoNewline "`r$percent%"
}

function FindAndRemoveDuplicates($files) {
    $hashToFile = @{}
    $totalFiles = $files.Count
    $currentFile = 0

    foreach ($file in $files) {
        $hash = Get-FileMD5 $file.FullName

        if ($hash -ne $null) {
            if ($hashToFile.ContainsKey($hash)) {
                Remove-Item $file.FullName -Force
                Write-Host "Deleted duplicate file: $($file.FullName)"
            } else {
                $hashToFile[$hash] = $file.FullName
            }
        }

        $currentFile++
        $percent = [math]::Round(($currentFile / $totalFiles) * 100, 2)
        Write-Percentage $percent
    }
    Write-Host ""
}

function CleanWindowsCache() {
    Write-Host "Cleaning Windows cache..."

    $tempPaths = @(
        $env:TEMP
        $env:TMP
        (Join-Path -Path $env:WINDIR -ChildPath "Temp")
    )

    foreach ($tempPath in $tempPaths) {
        Write-Host "Cleaning folder: $tempPath"
        Get-ChildItem -Path $tempPath -Recurse -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "Cache cleaning completed."
}

$today = Get-Date -Format "yyyy-MM-dd"
Write-Host "Starting cleaner on $today"

$foldersToScan = @("Documents", "Pictures", "Music", "Videos", "Desktop", "Downloads")
$files = @()

foreach ($folder in $foldersToScan) {
    $path = Join-Path -Path $env:USERPROFILE -ChildPath $folder
    $files += Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue
}

FindAndRemoveDuplicates $files
CleanWindowsCache
