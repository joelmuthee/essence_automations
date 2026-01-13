$files = Get-ChildItem -Recurse -Filter *.html

# The current inline-styled text we want to replace
$targetString = '<p style="color: var(--primary-color); font-weight: bold; margin-top: 1rem; font-size: 0.9rem;">As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!</p>'
$replacementString = '<p class="discount-text">As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!</p>'

foreach ($file in $files) {
    if ($file.FullName -like "*\node_modules\*") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content.Contains($targetString)) {
        $newContent = $content.Replace($targetString, $replacementString)
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
    else {
        # Fallback check for the version without font-size if any missed update
        $fallbackTarget = '<p style="color: var(--primary-color); font-weight: bold; margin-top: 1rem;">As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!</p>'
        if ($content.Contains($fallbackTarget)) {
            $newContent = $content.Replace($fallbackTarget, $replacementString)
            $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
            Write-Host "Updated $($file.Name) (from fallback)"
        }
        else {
            Write-Host "No match in $($file.Name)"
        }
    }
}
