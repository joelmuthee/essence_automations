$fileServiceMap = @{
    "websites.html"              = "Ultra-modern Websites"
    "ai-chat.html"               = "AI Support Chat"
    "gmb-manager.html"           = "GBP Booster"
    "crm.html"                   = "CRM With App"
    "ads-manager.html"           = "AI Ads Manager"
    "reputation-management.html" = "Google Reviews"
    "sms-marketing.html"         = "SMS & WhatsApp Marketing"
    "email-marketing.html"       = "Email Marketing"
    "online-calendar.html"       = "Online Appointment Calendar"
    "documents.html"             = "Document Management"
    "social-planner.html"        = "Social Media Management"
    "qr-codes.html"              = "QR Codes"
    "index.html"                 = "" # index.html might need specific handling or generic
}

# Generic replacement for all files to use the showServicesPopup function
# We target the specific onclick pattern we created earlier:
# onclick="const p = document.getElementById('services-needed-popup'); p.classList.remove('hidden'); p.scrollIntoView({behavior: 'smooth', block: 'start'});"

# And replace it with: onclick="showServicesPopup('SERVICE_NAME')"

foreach ($file in $fileServiceMap.Keys) {
    if (Test-Path $file) {
        $serviceName = $fileServiceMap[$file]
        $content = Get-Content -Path $file -Raw -Encoding UTF8
        
        $searchPattern = "onclick=`"const p = document.getElementById\('services-needed-popup'\); p.classList.remove\('hidden'\); p.scrollIntoView\(\{behavior: 'smooth', block: 'start'\}\);`""
        
        # If index.html, we might want to be careful as it links to multiple services, but usually the "Interested" buttons are generic or section specific.
        # However, looking at index.html, it often redirects to specific pages.
        # If there are popups on index.html, we should verify. 
        # But for now, let's assume index.html uses specific links or if it has a popup, it's generic.
        
        if ($file -eq "index.html") {
            # Index page "Book Demo" or "Interested" usually goes to anchors or generic form handling.
            # If exact match found, maybe use "General Inquiry" or null which defaults to Google Reviews? 
            # Let's map it to "General Inquiry" or just "Consultation"
            $serviceName = "Consultation"
        }

        $replacement = "onclick=`"showServicesPopup('$serviceName')`""
        
        # We need to perform the replacement. String.Replace is easiest if exact match.
        # The previous script standardized the string, so it should match exactly.
        
        $targetString = "onclick=`"const p = document.getElementById('services-needed-popup'); p.classList.remove('hidden'); p.scrollIntoView({behavior: 'smooth', block: 'start'});`""
        
        if ($content.Contains($targetString)) {
            $newContent = $content.Replace($targetString, $replacement)
            Set-Content -Path $file -Value $newContent -Encoding UTF8
            Write-Host "Updated $file to use showServicesPopup('$serviceName')"
        }
        else {
            Write-Host "Pattern not found in $file - skipping"
        }
    }
}
