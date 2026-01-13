$files = Get-ChildItem -Recurse -Filter *.html

foreach ($file in $files) {
    if ($file.Name -eq "documents.html") {
        # Example skip if needed, but we don't need to skip any
        # continue
    }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Update style.css?v=29 -> v=30 (or whatever it is, force to 30)
    # Using regex to match style.css?v=\d+
    $newContent = $content -replace 'style\.css\?v=\d+', 'style.css?v=30'
    
    # Update main.js?v=20 or 21 -> v=22
    $newContent = $newContent -replace 'main\.js\?v=\d+', 'main.js?v=22'
    
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
else {
    Write-Host "$backupFile not found"
}
