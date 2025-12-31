$files = Get-ChildItem -Path . -Filter "*.html" | Where-Object { $_.Name -ne "index.html" }

$navContent = @"
                    <div class="dropdown-content glass-effect">
                        <a href="crm-mobile.html">CRM & Mobile App</a>
                        <a href="websites.html">Ultra-modern Websites</a>
                        <a href="sms-marketing.html">SMS Marketing</a>
                        <a href="email-marketing.html">Email Marketing</a>
                        <a href="ai-chat.html">AI Chat</a>
                        <a href="online-calendar.html">Online Calendar</a>
                        <a href="documents.html">Documents</a>
                        <a href="gmb-manager.html">GMB Manager</a>
                        <a href="social-planner.html">Social Planner</a>
                        <a href="qr-codes.html">QR Codes</a>
                        <a href="reputation-management.html">Google Reviews</a>
                    </div>
"@

$footerContent = @"
                    <div class="footer-column">
                        <h4>Services</h4>
                        <a href="crm-mobile.html">CRM & Mobile</a>
                        <a href="websites.html">Ultra-modern Websites</a>
                        <a href="sms-marketing.html">SMS Marketing</a>
                        <a href="email-marketing.html">Email Marketing</a>
                        <a href="ai-chat.html">AI Chat</a>
                        <a href="online-calendar.html">Online Calendar</a>
                        <a href="documents.html">Documents</a>
                        <a href="gmb-manager.html">GMB Manager</a>
                        <a href="social-planner.html">Social Planner</a>
                        <a href="qr-codes.html">QR Codes</a>
                        <a href="reputation-management.html">Google Reviews</a>
                    </div>
"@

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Update Navigation
    $content = $content -replace '(?s)<div class="dropdown-content glass-effect">.*?</div>', $navContent
    
    # Update Footer - targeted more specifically if possible, but the column structure is consistent
    $content = $content -replace '(?s)<div class="footer-column">\s*<h4>Services</h4>.*?</div>', $footerContent

    # Standardize 'Websites' link name if it appears elsewhere (optional, but safer to stick to Nav/Footer blocks first)
    
    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($file.Name)"
}
