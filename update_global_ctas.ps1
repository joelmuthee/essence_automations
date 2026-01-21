$root = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $root -Filter "*.html" | Where-Object { $_.Name -ne "demos.html" }

$serviceMap = @{
    "websites.html"              = "Ultra-modern Websites"
    "ai-chat.html"               = "AI Support Chat"
    "gmb-manager.html"           = "GBP Booster"
    "crm-mobile.html"            = "CRM & Mobile App"
    "ads-manager.html"           = "AI Ads Manager"
    "reputation-management.html" = "Google Reviews"
    "sms-marketing.html"         = "SMS Marketing"
    "email-marketing.html"       = "Email Marketing"
    "online-calendar.html"       = "Online Appointment Calendar"
    "documents.html"             = "Document Management"
    "social-planner.html"        = "Social Media Management"
    "qr-codes.html"              = "QR Codes"
}

$popupHTML = '
        <!-- Services Needed Form (Pop-up/Inline) -->
        <div id="services-needed-popup" class="conditional-content hidden">
            <button class="close-form-btn" onclick="this.parentElement.classList.add(''hidden'');"
                title="Close Form">&times;</button>
            <iframe
                src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?zyqVSE2pWYgjr1m9135H={0}"
                style="display:none;width:100%;height:100%;border:none;border-radius:4px"
                id="popup-g9F8xoEZgZjMUDIIP6hN" data-layout=''{{ "id":"INLINE" }}'' data-trigger-type="alwaysShow"
                data-trigger-value="" data-activation-type="alwaysActivated" data-activation-value=""
                data-deactivation-type="neverDeactivate" data-deactivation-value=""
                data-form-name="Services Needed Form" data-height="849"
                data-layout-iframe-id="popup-g9F8xoEZgZjMUDIIP6hN" data-form-id="g9F8xoEZgZjMUDIIP6hN"
                title="Services Needed Form">
            </iframe>
            <script src="https://link.essenceautomations.com/js/form_embed.js"></script>
        </div>'

$ctaTemplate = '
            <div class="section-header">
                <h2 class="fade-in-up">Interested in {0}?</h2>
                <p>Provide your details and we''ll be in touch</p>
                <div style="margin-top: 2rem;">
                    <button onclick="showServicesPopup(''{0}'')" class="btn-primary"
                        style="border:none; cursor:pointer; font-family: inherit; font-size: 1rem;">I''m Interested</button>
                </div>
            </div>'

foreach ($file in $files) {
    if ($file.Name -eq "demos.html") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    # 1. Add Demos to Header (Check if "Book a Call" is missing)
    if ($content -notmatch 'Book a Call' -and $content -match 'href="rate-us.html"') {
        $content = $content -replace '<li><a href="rate-us.html">Rate Us</a></li>', 
        '<li><a href="rate-us.html">Rate Us</a></li>
                <li><a href="demos.html">Book a Call</a></li>'
        $modified = $true
    }
    
    # 2. Add Book a Call to Footer
    if ($content -match '<a href="rate-us.html">Rate Us</a>' -and $content -notmatch '<a href="demos.html">' ) {
        $content = $content -replace '(?<!<li>)<a href="rate-us.html">Rate Us</a>', 
        '<a href="rate-us.html">Rate Us</a>
                        <a href="demos.html">Book a Call</a>'
        $modified = $true
    }
    
    # Ensure "Demos" is renamed to "Book a Call" everywhere (Safety cleanup)
    if ($content -match '>Demos</a>') {
        $content = $content -replace '>Demos</a>', '>Book a Call</a>'
        $modified = $true
    }

    # 3. Swap CTA (Refined logic to update EXISTING "Interested" blocks too)
    if ($serviceMap.ContainsKey($file.Name)) {
        $serviceName = $serviceMap[$file.Name]
        $encodedService = [uri]::EscapeDataString($serviceName)
        
        # Regex to find OLD Calendar Section (In case any missed)
        $calendarPattern = '(?s)<div class="section-header">.*?<h2.*?>.*?</h2>.*?</div>\s*<div class="calendar-container.*?">.*?<iframe.*?booking/oO6WgghbYEmmjvXHx8fK.*?</iframe>.*?</div>'
        
        # Regex to find NEW "Interested" Section (To update service name or copy)
        # Matches any "Interested in" block
        $newCtaPattern = '(?s)<div class="section-header">.*?Interested in.*?<button onclick="showServicesPopup\(''.*?''\).*?I''m Interested</button>.*?</div>\s*</div>(?:\s*<!-- Services Needed Form.*?services-needed-popup.*?</div>)?'

        $matched = $false
        
        if ($content -match $calendarPattern) {
            Write-Host "Replacing Calendar in $($file.Name)"
            $newCTA = $ctaTemplate -f $serviceName
            $finalPopup = $popupHTML -f $encodedService
            $replacement = $newCTA + "`n" + $finalPopup
            $content = $content -replace $calendarPattern, $replacement
            $modified = $true
        }
        elseif ($content -match $newCtaPattern) {
            Write-Host "Updating CTA/Popup in $($file.Name)"
            $newCTA = $ctaTemplate -f $serviceName
            $finalPopup = $popupHTML -f $encodedService
            $replacement = $newCTA + "`n" + $finalPopup
            $content = $content -replace $newCtaPattern, $replacement
            $modified = $true
        }
        
        # Special case: Verify websites.html uses new copy if not caught by pattern (e.g. if I manually edited it differently)
        if ($file.Name -eq "websites.html") {
            if ($content -match "Let us know and we'll send you more details") {
                $content = $content -replace "Let us know and we'll send you more details", "Provide your details and we'll be in touch"
                $modified = $true
            }
        }
    }

    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
