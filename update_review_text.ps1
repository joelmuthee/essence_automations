$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$oldText = "Could you please spare a moment to leave us a google review?"
$newText = "Could you please spare a moment to share your experience on our Google Business Profile? Your detailed feedback helps us grow and serve you better."

Get-ChildItem -Path $targetDir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    
    if ($content -match [regex]::Escape($oldText)) {
        $newContent = $content -replace [regex]::Escape($oldText), $newText
        Set-Content -Path $path -Value $newContent -Encoding utf8
        Write-Host "Updated text in $($_.Name)"
    }
    else {
        Write-Host "Text not found or already updated in $($_.Name)"
    }
}
