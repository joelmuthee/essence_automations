$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
# Search for the exact string we just added
$searchString = '5 Stars = &#129321;'
$replacementString = '5 Stars = &#129392;' 
# &#129392; = 🥰 (Smiling Face with Hearts) - "Excellent/Loved it", no teeth.

Get-ChildItem -Path $targetDir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    
    if ($content -match $searchString) {
        $newContent = $content -replace $searchString, $replacementString
        Set-Content -Path $path -Value $newContent -Encoding utf8
        Write-Host "Updated emoji in $($_.Name)"
    }
    else {
        Write-Host "Emoji not found in $($_.Name)"
    }
}
