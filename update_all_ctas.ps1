# Mapping of file names to checkbox values
$ServiceMapping = @{
    "websites.html"              = "Ultra-modern Websites"
    "ai-chat.html"               = "AI Support Chat"
    "gmb-manager.html"           = "GBP Booster"
    "crm-mobile.html"            = "CRM & Mobile App"
    "ads-manager.html"           = "AI Ads Manager"
    "reputation-management.html" = "Google Reviews"
    "sms-marketing.html"         = "SMS Marketing"
    "email-marketing.html"       = "Email Marketing"
    "online-calendar.html"       = "Appointment Calendar"
    "documents.html"             = "Document Management"
    "social-planner.html"        = "Social Media Management"
    "qr-codes.html"              = "QR Codes"
}

$PopupTemplate = @"
            <!-- Services Needed Form (Pop-up/Inline) -->
            <div id="services-needed-popup" class="conditional-content hidden"
                style="min-height: 849px; max-width: 800px; margin: 2rem auto 0 auto;">
                <button class="close-form-btn" onclick="this.parentElement.classList.add('hidden');"
                    title="Close Form">&times;</button>
                <iframe src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={0}"
                    style="display:none;width:100%;height:100%;border:none;border-radius:4px"
                    id="popup-g9F8xoEZgZjMUDIIP6hN" data-layout="{{'id':'POPUP'}}" data-trigger-type="alwaysShow"
                    data-trigger-value="" data-activation-type="alwaysActivated" data-activation-value=""
                    data-deactivation-type="neverDeactivate" data-deactivation-value=""
                    data-form-name="Services Needed Form" data-height="849"
                    data-layout-iframe-id="popup-g9F8xoEZgZjMUDIIP6hN" data-form-id="g9F8xoEZgZjMUDIIP6hN"
                    title="Services Needed Form">
                </iframe>
                <script src="https://link.essenceautomations.com/js/form_embed.js"></script>
            </div>
"@

$OldButton1 = '<a href="index.html#contact" class="btn-primary">Get It Now</a>'
$OldButton2 = '<a href="#contact" class="btn-primary">Get It Now</a>'

$NewButton = '<button onclick="document.getElementById(''services-needed-popup'').classList.remove(''hidden'');" class="btn-primary" style="border:none; cursor:pointer; font-family: inherit; font-size: 1rem;">Get It Now</button>'

foreach ($file in $ServiceMapping.Keys) {
    if (-not (Test-Path $file)) {
        Write-Host "Skipping $file (Not Found)"
        continue
    }

    $serviceValue = $ServiceMapping[$file]
    # URL Encode the service value
    $encodedValue = [System.Web.HttpUtility]::UrlEncode($serviceValue)
    
    # PowerShell sometimes needs assembly loading for HttpUtility, fallback to manual logic if needed or .NET method
    if (-not $encodedValue) {
        $encodedValue = [uri]::EscapeDataString($serviceValue)
    }

    $content = Get-Content -Path $file -Raw
    $originalContent = $content

    # Skip reputation-management.html logic if already done correctly, but let's enforce standardisation
    # Note: reputation-management has slightly different context maybe, but CTA text is consistent.

    # 1. Update Button
    if ($content.Contains($OldButton1)) {
        $content = $content.Replace($OldButton1, $NewButton)
        Write-Host "Replaced Button 1 in $file"
    }
    elseif ($content.Contains($OldButton2)) {
        $content = $content.Replace($OldButton2, $NewButton)
        Write-Host "Replaced Button 2 in $file"
    }

    # 2. Insert or Update Popup
    if ($content.Contains('id="services-needed-popup"')) {
        # Update existing iframe SRC
        Write-Host "Updating iframe URL in $file"
        # Regex to find the src URL
        $pattern = 'src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN[^"]*"'
        $newSrc = 'src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed=' + $encodedValue + '"'
        $content = $content -replace $pattern, $newSrc

    }
    else {
        # Insert Popup
        # Find closing section tag of CTA
        # Search for "Want This On Your Site?"
        $ctaIndex = $content.IndexOf("Want This On Your Site?")
        
        if ($ctaIndex -ge 0) {
            $sectionEndIndex = $content.IndexOf("</section>", $ctaIndex)
            
            if ($sectionEndIndex -ge 0) {
                # Format template
                $popupCode = $PopupTemplate -f $encodedValue
                
                # Insert
                $content = $content.Substring(0, $sectionEndIndex) + $popupCode + $content.Substring($sectionEndIndex)
                Write-Host "Inserted popup in $file"
            }
            else {
                Write-Host "Could not find closing section tag in $file"
            }
        }
        else {
            Write-Host "CTA Section not found in $file"
        }
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "Saved changes to $file"
    }
}
