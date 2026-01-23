$files = @(
    "email-marketing.html",
    "documents.html",
    "crm.html",
    "ai-chat.html",
    "ads-manager.html",
    "about.html",
    "gmb-manager.html",
    "reputation-management.html",
    "sms-marketing.html",
    "social-planner.html",
    "websites.html",
    "qr-codes.html",
    "online-calendar.html",
    "faq.html"
)

$baseDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# Note: In PowerShell ensuring exact string matching with newlines can be tricky. 
# We'll use a slightly different approach: regex replace or carefully constructed strings.

# The target block to replace (multi-line string)
$targetBlock = @"
                <div class="footer-brand">
                    <div class="brand">Essence Automations</div>
                    <div class="contact-info">
                        <a href="tel:+254720615606">&#55357;&#56542; +254 720 615 606</a>
                        <a href="mailto:chat@essenceautomations.com">&#55357;&#56551; chat@essenceautomations.com</a>
                    </div>
                </div>
"@

# The replacement block
$replacementBlock = @"
                <div class="footer-brand">
                    <div class="brand">
                        <img src="essence-logo-full.png" alt="Essence Automations" class="footer-logo">
                    </div>
                    <div class="contact-info">
                        <a href="tel:+254720615606">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-telephone-fill" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 0 1 2.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.68.68 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
                            </svg>
                            +254 720 615 606
                        </a>
                        <a href="mailto:chat@essenceautomations.com">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope-fill" viewBox="0 0 16 16">
                                <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/>
                            </svg>
                            chat@essenceautomations.com
                        </a>
                    </div>
                </div>
"@

# Normalize line endings to Windows style for comparison if needed, 
# but simply replacing text content is usually safer done by reading as raw string.
# However, PowerShell's Get-Content returns an array of lines. -Raw returns a single string.

foreach ($file in $files) {
    $path = Join-Path $baseDir $file
    if (Test-Path $path) {
        $content = Get-Content -Path $path -Raw -Encoding UTF8
        
        # We need to be careful with whitespace. The HTML files likely use CRLF.
        # The Here-Strings in PowerShell usually respect the file's newline format if saved that way, 
        # but indentation in the script might differ from the target file.
        # To be robust, we'll try to match the specific content structure.
        
        if ($content.Contains('class="brand">Essence Automations</div>')) {
            # Let's use a replace for the brand div specifically, and then the contact info
            # Or try the full block replacement.
            
            # Simple check if already updated
            if ($content -match "essence-logo-full.png") {
                Write-Host "Skipping $file : already updated"
                continue
            }

            # Attempt full block replacement
            # We strip carriage returns from comparison variables to make it line-ending agnostic-ish
            # or just use simply Replace()
            $newContent = $content.Replace($targetBlock, $replacementBlock)
            
            if ($newContent -ne $content) {
                $newContent | Set-Content -Path $path -Encoding UTF8 -NoNewline
                Write-Host "Updated $file"
            }
            else {
                # If exact block match failed (due to whitespace), fall back to lesser replacement or manual fix.
                # Let's try to replace just the brand line and the contact info lines separately if needed, 
                # but let's see if the block works first.
                Write-Host "Warning: Exact block not found in $file. Attempting partial replacement..."
                
                # Partial Plan B:
                $content = $content -replace '<div class="brand">Essence Automations</div>', '<div class="brand"><img src="essence-logo-full.png" alt="Essence Automations" class="footer-logo"></div>'
                $content = $content -replace '<a href="tel:\+254720615606">&#55357;&#56542; \+254 720 615 606</a>', '<a href="tel:+254720615606"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-telephone-fill" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 0 1 2.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.68.68 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/></svg> +254 720 615 606</a>'
                $content = $content -replace '<a href="mailto:chat@essenceautomations.com">&#55357;&#56551; chat@essenceautomations.com</a>', '<a href="mailto:chat@essenceautomations.com"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope-fill" viewBox="0 0 16 16"><path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/></svg> chat@essenceautomations.com</a>'
                
                $content | Set-Content -Path $path -Encoding UTF8 -NoNewline
                Write-Host "Updated $file (Partial Fallback)"
            }
        }
        else {
            Write-Host "Target content not found in $file"
        }
    }
    else {
        Write-Host "File not found: $path"
    }
}

