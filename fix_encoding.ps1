$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"
foreach ($file in $files) {
    try {
        $content = Get-Content -Path $file.FullName -Raw
        $content | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Processed: $($file.Name)"
    }
    catch {
        Write-Host "Error processing $($file.Name): $_"
    }
}
