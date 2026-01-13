$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Check if content needs cleaning
    if ($content -match "#65279;" -or $content -match "&#65279;" -or $content.StartsWith([char]0xFEFF)) {
        
        # Remove literal BOM entities
        $content = $content -replace "#65279;", ""
        $content = $content -replace "&#65279;", ""
        
        # Remove actual Byte Order Mark if present at start
        if ($content.StartsWith([char]0xFEFF)) {
            $content = $content.Substring(1)
        }
        
        # Write back cleanly
        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
        Write-Host "Cleaned: $($file.Name)"
    }
}
Write-Host "Cleanup Complete!"
