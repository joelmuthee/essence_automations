$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # 1. Trim leading whitespace/newlines
    $content = $content.TrimStart()
    
    # 2. Fix broken DOCTYPEs
    if ($content.StartsWith("!DOCTYPE html>")) {
        $content = "<" + $content
        Write-Host "Fixed broken DOCTYPE in: $($file.Name)"
    }
    elseif ($content.StartsWith("DOCTYPE html>")) {
        $content = "<!" + $content
        Write-Host "Fixed broken DOCTYPE in: $($file.Name)"
    }
    
    # 3. Ensure it starts with correct DOCTYPE (safety check)
    if (-not $content.StartsWith("<!DOCTYPE html>")) {
        Write-Host "Warning: $($file.Name) does not start with standard <!DOCTYPE html>"
    }
    
    # Write back
    [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
}
Write-Host "Repair Complete!"
