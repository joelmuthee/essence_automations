# PowerShell Icon Restoration Script (ASCII SAFE & REGEX SAFE VERSION)
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function U([int]$code) {
    return [char]::ConvertFromUtf32($code)
}

# Define Emojis using Unicode Code Points
# 🎨 0x1F3A8
$Art = U 0x1F3A8
# 🛠️ 0x1F6E0
$Tools = U 0x1F6E0
# 📞 0x1F4DE
$Phone = U 0x1F4DE
# 📧 0x1F4E7
$Email = U 0x1F4E7
# 🗺️ 0x1F5FA
$Map = U 0x1F5FA
# ⭐ 0x2B50
$Star = U 0x2B50
# 📊 0x1F4CA
$Chart = U 0x1F4CA
# 💲 0x1F4B2
$Money = U 0x1F4B2
# ⚡ 0x26A1
$Zap = U 0x26A1
# ⚙️ 0x2699
$Gear = U 0x2699
# 💬 0x1F4AC
$Speech = U 0x1F4AC
# 💰 0x1F4B0
$Bag = U 0x1F4B0
# 🤖 0x1F916
$Bot = U 0x1F916
# 🎯 0x1F3AF
$Target = U 0x1F3AF
# 🔗 0x1F517
$Link = U 0x1F517
# 🌍 0x1F30D
$Earth = U 0x1F30D
# 🔔 0x1F514
$Bell = U 0x1F514
# 👥 0x1F465
$People = U 0x1F465
# 📱 0x1F4F1
$Mobile = U 0x1F4F1
# 🗓️ 0x1F5D3
$CalFrame = U 0x1F5D3
# 📅 0x1F4C5
$Cal = U 0x1F4C5
# 📄 0x1F4C4
$Page = U 0x1F4C4
# ✍️ 0x270D
$Pen = U 0x270D
# 👁️ 0x1F441
$Eye = U 0x1F441
# 🔒 0x1F512
$Lock = U 0x1F512
# 📥 0x1F4E5
$Inbox = U 0x1F4E5
# ↩️ 0x21A9
$Hook = U 0x21A9
# 📍 0x1F4CD
$Pin = U 0x1F4CD
# 📈 0x1F4C8
$Trend = U 0x1F4C8
# 📢 0x1F4E2
$Horn = U 0x1F4E2
# 🌐 0x1F310
$Globe = U 0x1F310
# 🌙 0x1F319
$Moon = U 0x1F319
# 🧲 0x1F9F2
$Magnet = U 0x1F9F2
# 🤝 0x1F91D
$Shake = U 0x1F91D
# 🔄 0x1F504
$Loop = U 0x1F504
# 👋 0x1F44B
$Wave = U 0x1F44B
# 🚀 0x1F680
$Rocket = U 0x1F680
# 💧 0x1F4A7
$Drop = U 0x1F4A7
# 📐 0x1F4D0
$Ruler = U 0x1F4D0
# 📂 0x1F4C2
$Folder = U 0x1F4C2
# ✅ 0x2705
$Check = U 0x2705
# 😞 0x1F61E
$Sad = U 0x1F61E
# 🤩 0x1F929
$StarEyes = U 0x1F929
# ▼ 0x25BC
$Down = U 0x25BC


$GlobalMap = @{
    'Services \?|Services &#9660;|Services &#\d+;' = "Services $Down"
    '\?\? \+254|&#\d+; &#\d+; \+254'               = "$Phone +254"
    '\?\? chat@|&#\d+; &#\d+; chat@'               = "$Email chat@"
}

$IconMap = @{
    'Modern Design'         = $Art
    'Integrated Tools'      = $Tools
    'Smart Contacts'        = $Phone
    'Interactive Maps'      = $Map
    'Filtered Reviews'      = $Star
    'Website Tracking'      = $Chart
    'Flexible Pricing'      = $Money
    
    'Instant Reach'         = $Zap
    'Automated Campaigns'   = $Gear
    '2-Way Conversations'   = $Speech
    'High ROI'              = $Bag
    
    'Drag & Drop Builder'   = $Art
    'Smart Automation'      = $Bot
    'Precise Segmentation'  = $Target
    'Detailed Analytics'    = $Chart
    
    'Easy Integration'      = $Link
    'Embed & Share'         = $Earth
    'Automated Reminders'   = $Bell
    'Team Scheduling'       = $People
    
    'Multi-Platform'        = $Mobile
    'Bulk Scheduling'       = $CalFrame
    'Content Calendar'      = $Cal
    'Analytics'             = $Chart
    
    'Templates'             = $Page
    'E-Signatures'          = $Pen
    'Tracking'              = $Eye
    'Secure Storage'        = $Lock
    
    'Unified Inbox'         = $Inbox
    'Pipeline Management'   = $Chart
    'Mobile App'            = $Mobile
    'Missed Call Text Back' = $Hook
    
    'Local SEO'             = $Pin
    'Customer Interaction'  = $Speech
    'Insights'              = $Trend
    'Post Updates'          = $Horn
    
    'Cross-Platform'        = $Globe
    'AI Optimization'       = $Bot
    'Real-Time Analytics'   = $Chart
    'Budget Control'        = $Bag
    
    '24/7 Availability'     = $Moon
    'Lead Capture'          = $Magnet
    'Instant Answers'       = $Zap
    'Human Handoff'         = $Shake
    
    'Dynamic Codes'         = $Loop
    'Custom Design'         = $Art
    'Tracking & Analytics'  = $Chart
    'Touchless Interaction' = $Wave

    # Documents Management (Exact Titles)
    'Proposals & Estimates' = U 0x1F4DD # Memo
    'Digital Signatures'    = $Pen
    'Template Library'      = $Folder
    'Auto-Populate'         = $Zap

    # QR Codes (Exact Titles)
    'Dynamic QR Codes'      = $Loop
    'Custom Designs'        = $Art
    'Advanced Analytics'    = $Chart
    'Review Collection'     = $Star

    # Social Planner (Already present, reinforcing)
    'Image Editor'          = $Art
    'One-Click Publishing'  = $Rocket
    'Watermark Feature'     = $Drop
    'Smart Resizing'        = $Ruler
    'AI Content Assistant'  = $Bot
    'CSV Bulk Uploader'     = $Folder
    'Approval Workflow'     = $Check
    'Stats & RSS Feeds'     = $Trend

    # Reputation Management
    'Negative Shield'       = U 0x1F6E1
    'Google Booster'        = $Star
    'Seamless Integration'  = $Loop
    'Review Widget'         = $StarEyes
    'Actionable Insights'   = $Trend
}

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read as UTF8
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # 1. Global Replacements
    foreach ($key in $GlobalMap.Keys) {
        $val = $GlobalMap[$key]
        $content = [Regex]::Replace($content, $key, $val)
    }
    
    # 2. Context Icon Replacements
    foreach ($title in $IconMap.Keys) {
        $icon = $IconMap[$title]
        # Regex escaping
        $safeTitle = [Regex]::Escape($title)
        
        # USE SAFE REGEX: (?!</div>) ensures we don't cross a closing div
        # We assume the corrupted icon is inside the closest preceding div
        $pattern = "(?s)<div class=""icon"">(?:(?!</div>).)*?</div>(\s*<h3>$safeTitle</h3>)"
        
        if ($content -match $pattern) {
            $replacement = "<div class=""icon"">$icon</div>`$1"
            $content = [Regex]::Replace($content, $pattern, $replacement)
        }
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Restored icons in $($file.Name)"
    }
}
