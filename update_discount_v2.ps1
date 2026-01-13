$files = Get-ChildItem -Recurse -Filter *.html

# The text we inserted in the last step (without the HTML tags for finding it, or with them)
# We can just match the core sentence to be safe.
$oldCoreText = "As a token of our appreciation, show your review to receive a discount on your next payment!"
$newCoreText = "As a token of our appreciation, your 5-star Google review earns you a discount on your next payment!"

foreach ($file in $files) {
    if ($file.FullName -like "*\node_modules\*") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content -match [regex]::Escape($oldCoreText)) {
        $newContent = $content -replace [regex]::Escape($oldCoreText), $newCoreText
        
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
    else {
        # Debug: Check if maybe the old "show this screen" text is still there?
        if ($content -match "As a token of our appreciation, show this screen") {
            Write-Host "Found old version in $($file.Name), updating..."
            $newContent = $content -replace "As a token of our appreciation, show this screen next time you visit for a discount!", $newCoreText
            $newContent | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        }
        else {
            Write-Host "No match in $($file.Name)"
            # Search if it already has the new text?
            if ($content -match [regex]::Escape($newCoreText)) {
                Write-Host "  (Already has new text)"
            }
        }
    }
}
