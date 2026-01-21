$files = @(
    "websites.html",
    "ai-chat.html",
    "gmb-manager.html",
    "ads-manager.html",
    "reputation-management.html",
    "sms-marketing.html",
    "email-marketing.html",
    "online-calendar.html",
    "documents.html",
    "social-planner.html",
    "qr-codes.html"
)

$basePath = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$poweredByHtml = '<br><span style="font-size: 0.8em; opacity: 0.8;">Powered by GoHighLevel</span>'

foreach ($file in $files) {
    $path = Join-Path $basePath $file
    if (Test-Path $path) {
        Write-Host "Processing $file..."
        $content = Get-Content -Path $path -Raw -Encoding UTF8
        
        # Regex to find the hero paragraph: <p class="fade-in-up delay-1">Content</p>
        # We want to insert the span before the closing </p>
        
        $regex = '(<p class="fade-in-up delay-1">.*?)(\s*<\/p>)'
        
        if ($content -match $regex) {
            # Check if it already has the span to avoid duplication
            if ($content -notmatch "Powered by GoHighLevel") {
                $content = $content -replace $regex, ('$1' + $poweredByHtml + '$2')
                Write-Host "  - Updated subheadline."
                Set-Content -Path $path -Value $content -Encoding UTF8
            }
            else {
                Write-Host "  - Already updated."
            }
        }
        else {
            Write-Warning "  - Hero paragraph not found!"
        }
    }
}
Write-Host "Global branding update complete."
