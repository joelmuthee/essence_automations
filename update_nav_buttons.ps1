$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations" -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content

    # 1. Remove the standalone 'Schedule a Meeting' link
    # We use a regex that handles potential whitespace around the tag
    $content = $content -replace '(?m)^\s*<li><a href="demos\.html">Schedule a Meeting</a></li>\s*$', ''

    # 2. Update the 'Get Started' button to become 'Schedule a Meeting' linking to demos.html
    # We match the specific pattern seen in index.html, handling the line break inside the link text if present
    # Pattern matches: <li><a href="#" [attributes] class="btn-primary">Get [newlines/spaces] Started</a></li>
    $content = $content -replace '<li><a href="#" onclick="showServicesPopup\(''General Inquiry''\); return false;" class="btn-primary">\s*Get\s+Started</a></li>', '<li><a href="demos.html" class="btn-primary">Schedule a Meeting</a></li>'
    
    # Fallback/Safety: Try matching simpler version if the specific onclick differs or if previously modified (just in case)
    # This specifically targets the "Get Started" button with btn-primary class if the above didn't catch it due to exact string mismatch
    if ($content -eq $originalContent -and $content -match 'Get\s+Started') {
        $content = $content -replace '<li><a href="[^"]*"[^>]*class="btn-primary"[^>]*>\s*Get\s+Started</a></li>', '<li><a href="demos.html" class="btn-primary">Schedule a Meeting</a></li>'
    }

    if ($content -ne $originalContent) {
        Write-Host "Updating navigation in $($file.Name)..."
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}
Write-Host "Navigation update complete."
