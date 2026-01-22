$files = Get-ChildItem -Recurse -Filter *.html

foreach ($file in $files) {
    if ($file.Name -eq "documents.html") {
        # Example skip if needed, but we don't need to skip any
        # continue
    }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Update style.css?v=64 -> v65
    $newContent = $content -replace 'style\.css\?v=\d+', 'style.css?v=65'
    
    # Update main.js?v=57 -> v58
    $newContent = $newContent -replace 'main\.js\?v=\d+', 'main.js?v=58'
    
    if ($newContent -ne $content) {
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}

# Delete the backup file
$backupFile = "Essence_Automations_Backup.zip"
if (Test-Path $backupFile) {
    Remove-Item $backupFile -Force
    Write-Host "Deleted $backupFile"
}

# Create new backup
Write-Host "Creating new backup..."
Get-ChildItem -Exclude $backupFile | Compress-Archive -DestinationPath $backupFile
Write-Host "Backup created: $backupFile"
