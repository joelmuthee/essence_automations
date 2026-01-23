
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# Files to TRANSFORM (Demo -> Real Review)
# Exclude reputation-management.html as it SHOULD behave like a Demo
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
    "crm.html",
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
        $modified = $false
        
        # 1. Remove LIVE DEMO Badge
        $badgePattern = '(?s)<span[^>]*style="[^"]*background: rgba\(255, 133, 32, 0\.2\)[^"]*"[^>]*>\s*LIVE\s+DEMO\s*</span>'
        if ($content -match $badgePattern) {
            $content = $content -replace $badgePattern, ""
            $modified = $true
        }

        # 2. Change Headline
        # Regex to match <h2 ...>Experience It Yourself</h2> with any attributes
        $h2Pattern = '(?s)<h2[^>]*>\s*Experience It Yourself\s*</h2>'
        if ($content -match $h2Pattern) {
            # We want to keep the attributes, just change the text.
            # Easiest way is to match the opening tag, then text, then closing tag.
            # But replace needs to know what to put back.
            
            # Simple approach: Replace the known string if we can trust the structure, 
            # Or use a capture group.
            
            # Capture the opening tag
            $content = $content -replace '(<h2[^>]*>)\s*Experience It Yourself\s*(</h2>)', '$1Rate Your Experience$2'
            $modified = $true
        }
        
        # 3. Change Subtitle
        # Regex to handle potential whitespaces or slight variations, though exact string match is usually safer if known
        if ($content -match 'Try selecting any star from 1 to 5 to see how it works\.') {
            $content = $content -replace 'Try selecting any star from 1 to 5 to see how it works\.', 'We value your feedback. Please select a star to rate us.'
            $modified = $true
        }
        
        if ($modified) {
            Write-Host "Updated $filename"
            [System.IO.File]::WriteAllText($filepath, $content)
        }
        else {
            Write-Host "No changes needed for $filename"
        }
    }
    else {
        Write-Host "File not found: $filename"
    }
}

