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
                src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={0}"
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
                <p>Let us know and we''ll send you more details.</p>
                <div style="margin-top: 2rem;">
                    <button onclick="showServicesPopup(''{0}'')" class="btn-primary"
                        style="border:none; cursor:pointer; font-family: inherit; font-size: 1rem;">I''m Interested</button>
                </div>
            </div>'

foreach ($file in $files) {
    if ($file.Name -eq "demos.html") { continue }
    
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    # 1. Add Demos to Header
    if ($content -notmatch 'href="demos.html"' -and $content -match 'href="rate-us.html"') {
        $content = $content -replace '<li><a href="rate-us.html">Rate Us</a></li>', 
        '<li><a href="rate-us.html">Rate Us</a></li>
                <li><a href="demos.html">Demos</a></li>'
        $modified = $true
    }
    
    # 2. Add Demos to Footer
    # Use a regex that finds Rate Us link NOT followed by Demos
    # But simple Replace is safer if we check -notmatch first (done above)
    # BE CAREFUL: Header replace added typos? No, looks ok.
    # Footer replace:
    if ($content -match '<a href="rate-us.html">Rate Us</a>' -and $content -notmatch '<a href="demos.html">' ) {
        # Identify footer context. Just Replace the string. 
        # The header one is already replaced, so it contains Demos now.
        # So searching for "Rate Us" WITHOUT "Demos" nearby is tricky globally.
        # But the header ONE is `<li><a...`. The footer ONE is just `<a...`.
        $content = $content -replace '(?<!<li>)<a href="rate-us.html">Rate Us</a>', 
        '<a href="rate-us.html">Rate Us</a>
                        <a href="demos.html">Demos</a>'
        $modified = $true
    }

    # 3. Swap CTA
    if ($serviceMap.ContainsKey($file.Name)) {
        $serviceName = $serviceMap[$file.Name]
        $encodedService = [uri]::EscapeDataString($serviceName)
        
        # Regex to find Calendar Section
        # Matches <div class="section-header"> ... <iframe ... booking ... iframe> ... </div>
        # We need to capture the whole inner content of the section to replace it.
        # Or just the iframe container?
        # The Python script matched: section-header...calendar-container...iframe...
        
        $pattern = '(?s)<div class="section-header">.*?<h2.*?>.*?</h2>.*?</div>\s*<div class="calendar-container.*?">.*?<iframe.*?booking/oO6WgghbYEmmjvXHx8fK.*?</iframe>.*?</div>'
        
        if ($content -match $pattern) {
            Write-Host "Found Calendar in $($file.Name)"
            $newCTA = $ctaTemplate -f $serviceName
            $content = $content -replace $pattern, $newCTA
            $modified = $true
        }
        
        # Check if CTA was updated (either now or previously) but Popup is missing
        if ($content -match "I'm Interested" -and $content -notmatch 'id="services-needed-popup"') {
            Write-Host "Injecting missing popup in $($file.Name)"
            $finalPopup = $popupHTML -f $encodedService
            
            # regex to match the end of the CTA block
            # Matches: I'm Interested</button> ... </div> ... </div>
            $ctaEndPattern = '(?s)(I''m Interested</button>.*?</div>\s*</div>)'
            
            if ($content -match $ctaEndPattern) {
                $content = $content -replace $ctaEndPattern, ('$1' + $finalPopup)
                $modified = $true
            }
            else {
                Write-Warning "Could not find CTA end to inject popup in $($file.Name)"
            }
        }
        elseif ($file.Name -eq "websites.html") {
            # Special case: websites.html has the BUTTON but OLD TEXT "Start Your Build"
            # And it HAS the popup already.
            Write-Host "Updating copy in websites.html"
            $content = $content -replace 'Start Your Build', "Interested in $serviceName?"
            $content = $content -replace 'Ready to launch your ultra-modern website\?', "Let us know and we'll send you more details."
            $content = $content -replace 'Get Your Website Now', "I'm Interested"
            $modified = $true
        }
    }

    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
