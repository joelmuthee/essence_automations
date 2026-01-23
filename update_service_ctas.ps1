# Service Page Mapping
$ServiceMapping = @{
    "websites.html"        = "Ultra-modern Websites"
    "ai-chat.html"         = "AI Support Chat"
    "gmb-manager.html"     = "GBP Booster"
    "crm.html"      = "CRM & Mobile App"
    "ads-manager.html"     = "AI Ads Manager"
    "sms-marketing.html"   = "SMS Marketing"
    "email-marketing.html" = "Email Marketing"
    "online-calendar.html" = "Appointment Calendar"
    "documents.html"       = "Document Management"
    "social-planner.html"  = "Social Media Management"
    "qr-codes.html"        = "QR Codes"
}
# reputation-management.html is excluded as it was manually customized.

$PopupTemplate = @"
            <!-- Services Needed Form (Pop-up/Inline) -->
            <div id="services-needed-popup" class="conditional-content hidden"
                style="min-height: 849px; max-width: 800px; margin: 2rem auto 0 auto; text-align: left;">
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

foreach ($file in $ServiceMapping.Keys) {
    if (-not (Test-Path $file)) {
        Write-Host "Skipping $file (Not Found)"
        continue
    }

    $serviceValue = $ServiceMapping[$file]
    $encodedValue = [uri]::EscapeDataString($serviceValue)
    $formattedPopup = $PopupTemplate -f $encodedValue

    $content = Get-Content -Path $file -Raw
    $originalContent = $content

    # 1. Replace Calendar Container with Button + Popup
    # Regex to capture the calendar container div and its content
    # We look for class="calendar-container..." and the closing div
    # This simple regex assumes the container structure is standard as seen in files
    
    $calendarPattern = '(?s)<div class="calendar-container[^"]*"(.*?)<\/div>'
    
    if ($content -match $calendarPattern) {
        # Check if we already updated it (contains services-needed-popup)
        if (-not ($content -match 'id="services-needed-popup"')) {
            $replacement = @"
<div class="calendar-container glass-effect" style="height: auto; padding: 2rem; text-align: center;">
                <button onclick="document.getElementById('services-needed-popup').classList.remove('hidden');" class="btn-primary" style="border:none; cursor:pointer; font-size: 1.2rem; padding: 1rem 2rem;">Get Started</button>
$formattedPopup
            </div>
"@
            $content = $content -replace $calendarPattern, $replacement
            Write-Host "Replaced Calendar in $file"
        }
        else {
            Write-Host "Popup already present in $file (skipping calendar replace)"
        }
    }
    else {
        Write-Host "Calendar container not found in $file"
    }

    # 2. Update Hero Button (linking to #contact)
    # Pattern: <a href="#contact" class="btn-primary">TEXT</a>
    # We replace it with <button ...>TEXT</button>
    
    $heroBtnPattern = '<a href="#contact" class="btn-primary">([^<]+)</a>'
    
    if ($content -match $heroBtnPattern) {
        # We use a script block for replacement to capture the text
        $content = [Regex]::Replace($content, $heroBtnPattern, { param($match) 
                $btnText = $match.Groups[1].Value
                return "<button onclick=`"document.getElementById('services-needed-popup').classList.remove('hidden');`" class=`"btn-primary`" style=`"border:none; cursor:pointer;`">$btnText</button>"
            })
        Write-Host "Updated Hero Button in $file"
    }
    
    # 2b. Update Hero Button (linking to index.html#contact - sometimes used)
    $heroBtnPattern2 = '<a href="index.html#contact" class="btn-primary">([^<]+)</a>'
    if ($content -match $heroBtnPattern2) {
        $content = [Regex]::Replace($content, $heroBtnPattern2, { param($match) 
                $btnText = $match.Groups[1].Value
                return "<button onclick=`"document.getElementById('services-needed-popup').classList.remove('hidden');`" class=`"btn-primary`" style=`"border:none; cursor:pointer;`">$btnText</button>"
            })
        Write-Host "Updated Hero Button (Type 2) in $file"
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $file -Value $content -NoNewline
        Write-Host "Saved changes to $file"
    }
}

