$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations" -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content

    # 1. Remove the standalone 'Schedule a Meeting' link if it still exists (idempotent check)
    if ($content -match '<li><a href="demos\.html">Schedule a Meeting</a></li>') {
        $content = $content -replace '(?m)^\s*<li><a href="demos\.html">Schedule a Meeting</a></li>\s*$', ''
    }

    # 2. Update ANY 'Get Started' button with class 'btn-primary' to 'Schedule a Meeting' linking to demos.html
    # This regex matches:
    # <li><a ... >Get Started</a></li>
    # It allows for different hrefs (#contact, #, #services, etc.) and attributes (onclick, etc.)
    # It ensures class="btn-primary" is present to avoid targeting other links
    $content = $content -replace '<li><a href="[^"]*"[^>]*class="btn-primary"[^>]*>\s*Get\s+Started</a></li>', '<li><a href="demos.html" class="btn-primary">Schedule a Meeting</a></li>'
    
    if ($content -ne $originalContent) {
        Write-Host "Refining navigation in $($file.Name)..."
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}
Write-Host "Navigation refinement complete."
