$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

Get-ChildItem -Path $targetDir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    
    # Replace corrupted characters with HTML entity
    if ($content -match "â˜…") {
        $content = $content -replace "â˜…", "&#9733;"
        Set-Content -Path $path -Value $content -Encoding utf8
        Write-Host "Fixed corrupted stars in $($_.Name)"
    }
    # Replace literal stars with HTML entity to be safe
    elseif ($content -match "★") {
        $content = $content -replace "★", "&#9733;"
        Set-Content -Path $path -Value $content -Encoding utf8
        Write-Host "Replaced literal stars in $($_.Name)"
    }
    else {
        Write-Host "No stars found or already fixed in $($_.Name)"
    }
}
