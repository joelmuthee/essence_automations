$files = @(
    "index.html",
    "email-marketing.html",
    "documents.html",
    "crm-mobile.html",
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
    "faq.html",
    "rate-us.html"
)

$baseDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# The replacement block (using exactly what we want)
# We need to escape double quotes for PowerShell string if needed, or use @" "@
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

# Regex to find the <div class="footer-brand"> ... </div> block
# (?s) allows . to match newlines
$pattern = '(?s)<div class="footer-brand">.*?<div class="brand">.*?</div>\s*<div class="contact-info">.*?</div>\s*</div>'

foreach ($file in $files) {
    $path = Join-Path $baseDir $file
    if (Test-Path $path) {
        $content = Get-Content -Path $path -Raw -Encoding UTF8
        
        # Check if we need to replace
        # We can try to replace unconditionally if it matches the structure
        if ($content -match $pattern) {
            # Perform replacement
            # Note: The pattern might match loosely, so we simply replace the matched part with our block.
            $newContent = [regex]::Replace($content, $pattern, $replacementBlock)
            
            if ($newContent -ne $content) {
                $newContent | Set-Content -Path $path -Encoding UTF8 -NoNewline
                Write-Host "Updated $file"
            }
            else {
                Write-Host "No change for $file (already correct?)"
            }
        }
        else {
            Write-Host "Pattern not found in $file. Checking manual snippets..."
            # It might be that the garbled text broke the regex structure if tags were malformed?
            # Or maybe the indentation is different.
            # Let's try a simpler regex to catch just the footer-brand wrapper if possible
            if ($content -match '(?s)<div class="footer-brand">.*?</div>\s*</div>') {
                # Warning: this might be too greedy if not careful about nested divs
                # But we know footer-brand contains brand and contact-info.
                Write-Host "  Trying broader match..."
            }
        }
    }
}
