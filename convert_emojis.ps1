$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalLength = $content.Length
    
    # Regex to find non-ASCII characters
    $newContent = [Regex]::Replace($content, "[^\u0000-\u007F]", {
            param($match)
            $char = $match.Value
            # Convert to code point
            $codePoint = [int][char]$char
            return "&#$codePoint;"
        })

    if ($newContent.Length -ne $originalLength) {
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Updated: $($file.Name) (Replaced emojis with entities)"
    }
    else {
        Write-Host "Skipped: $($file.Name) (No emojis found)"
    }
}
