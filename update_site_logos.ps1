$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $directory -Filter "*.html"

# Header Replacement Patterns
$headerFind = '<a href="index.html" class="logo">Essence<span class="highlight">Automations</span></a>'
# Note: Escape double quotes for PowerShell string if needed, but in single quotes it's fine.
$headerReplace = '<a href="index.html" class="logo"><img src="logo-header.png" alt="Essence Automations" style="height: 50px;"></a>'

# Footer Replacement Patterns
$footerFind = '<img src="essence-logo-full.png" alt="Essence Automations" class="footer-logo">'
$footerReplace = '<img src="logo-footer.png" alt="Essence Automations" class="footer-logo">'

$count = 0
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    # Replace Header
    if ($content.Contains($headerFind)) {
        $content = $content.Replace($headerFind, $headerReplace)
        $modified = $true
    }
    
    # Replace Footer
    if ($content.Contains($footerFind)) {
        $content = $content.Replace($footerFind, $footerReplace)
        $modified = $true
    }
    
    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Updated: $($file.Name)"
        $count++
    }
}

Write-Host "Total files updated: $count"
