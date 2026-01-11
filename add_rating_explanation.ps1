$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$searchString = '<p class="subtitle fade-in-up">Select a star rating below to share your feedback.</p>'
$replacementString = '<p class="subtitle fade-in-up">Select a star rating below to share your feedback.<br><span style="font-size: 0.9em; opacity: 0.8; font-weight: 300;">(1 Star = Very Poor, 5 Stars = Excellent)</span></p>'

Get-ChildItem -Path $targetDir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    
    if ($content -match [regex]::Escape($searchString)) {
        $newContent = $content -replace [regex]::Escape($searchString), $replacementString
        Set-Content -Path $path -Value $newContent -Encoding utf8
        Write-Host "Updated explanation in $($_.Name)"
    }
    else {
        Write-Host "Subtitle not found or already updated in $($_.Name)"
    }
}
