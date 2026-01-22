
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# Files to CLEAN (remove the section from)
$filesToClean = @(
    "websites.html",
    "social-planner.html",
    "sms-marketing.html",
    "online-calendar.html",
    "index.html",
    "gmb-manager.html",
    "faq.html",
    "email-marketing.html",
    "documents.html",
    "crm-mobile.html",
    "ai-chat.html",
    "ads-manager.html",
    "about.html",
    "qr-codes.html",
    "reference_site.html",
    "rate-us.html"
)

foreach ($filename in $filesToClean) {
    $filepath = Join-Path $directory $filename
    if (Test-Path $filepath) {
        $content = [System.IO.File]::ReadAllText($filepath)
        
        # Regex to find <section id="feedback-system" ... </section>
        # Single line mode (?s) to match across lines
        $pattern = '(?s)<section\s+[^>]*id="feedback-system".*?</section>'
        
        if ($content -match $pattern) {
            Write-Host "Removing feedback-system from $filename"
            $newContent = $content -replace $pattern, ""
            [System.IO.File]::WriteAllText($filepath, $newContent)
        }
        else {
            Write-Host "Section not found in $filename"
        }
    }
    else {
        Write-Host "File not found: $filename"
    }
}
