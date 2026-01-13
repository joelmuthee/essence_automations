$files = Get-ChildItem -Recurse -Filter *.html

$targetString = '<p style="color: var(--primary-color); font-weight: bold; margin-top: 1rem;">As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!</p>'
$replacementString = '<p style="color: var(--primary-color); font-weight: bold; margin-top: 1rem; font-size: 0.9rem;">As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!</p>'

foreach ($file in $files) {
    if ($file.FullName -like "*\node_modules\*") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # We use Replace method directly since it's a fixed string
    if ($content.Contains($targetString)) {
        $newContent = $content.Replace($targetString, $replacementString)
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
    else {
        Write-Host "No exact match in $($file.Name)"
    }
}
