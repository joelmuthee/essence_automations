$files = Get-ChildItem -Recurse -Filter *.html

$newText = '<p style="color: var(--primary-color); font-weight: bold; margin-top: 1rem;">As a token of our appreciation, show your review to receive a discount on your next payment!</p>'

# Regex to find existing similar text (loose match)
$existingPattern = '(?s)<p[^>]*>\s*As a token of our appreciation.*?discount.*?</p>'

# Regex to find insertion point if not found (end of the main p tag)
# Matches: ...serve you better.</p> and captures it to append after
$insertPattern = '(?s)(serve you better\.</p>)'

foreach ($file in $files) {
    if ($file.FullName -like "*\node_modules\*") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    $modified = $false
    
    # 1. Try to replace existing text if it exists
    if ($content -match $existingPattern) {
        $content = $content -replace $existingPattern, $newText
        $modified = $true
        Write-Host "Updated existing discount text in $($file.Name)"
    }
    # 2. If not found, try to insert it after the main paragraph in #review-cta
    elseif ($content -match 'id="review-cta"') {
        # Check if we have the insertion point inside review-cta
        # This is a bit tricky with global replace, so we scope it to the file
        if ($content -match $insertPattern) {
            # Ensure we don't insert if it's already there (double check)
            if ($content -notmatch "As a token of our appreciation") {
                $content = $content -replace $insertPattern, ('$1' + "`n                    " + $newText)
                $modified = $true
                Write-Host "Inserted discount text in $($file.Name)"
            }
        }
    }
    
    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
    }
}
