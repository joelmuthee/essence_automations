# PowerShell Icon Restoration Script

# Set console to UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$GlobalMap = @{
    'Services \?'                       = 'Services ▼'
    '\?\? \+254'                        = '📞 +254'
    '\?\? chat@'                        = '📧 chat@'
    '\(1 Star = \?\?, 5 Stars = \?\?\)' = '(1 Star = 😞, 5 Stars = 🤩)'
}

$IconMap = @{
    'Modern Design'         = '🎨'
    'Integrated Tools'      = '🛠️'
    'Smart Contacts'        = '📞'
    'Interactive Maps'      = '🗺️'
    'Filtered Reviews'      = '⭐'
    'Website Tracking'      = '📊'
    'Flexible Pricing'      = '💲'
    
    'Instant Reach'         = '⚡'
    'Automated Campaigns'   = '⚙️'
    '2-Way Conversations'   = '💬'
    'High ROI'              = '💰'
    
    'Drag & Drop Builder'   = '🎨'
    'Smart Automation'      = '🤖'
    'Precise Segmentation'  = '🎯'
    'Detailed Analytics'    = '📊'
    
    'Easy Integration'      = '🔗'
    'Embed & Share'         = '🌍'
    'Automated Reminders'   = '🔔'
    'Team Scheduling'       = '👥'
    
    'Multi-Platform'        = '📱'
    'Bulk Scheduling'       = '🗓️'
    'Content Calendar'      = '📅'
    'Analytics'             = '📊'
    
    'Templates'             = '📄'
    'E-Signatures'          = '✍️'
    'Tracking'              = '👁️'
    'Secure Storage'        = '🔒'
    
    'Unified Inbox'         = '📥'
    'Pipeline Management'   = '📊'
    'Mobile App'            = '📱'
    'Missed Call Text Back' = '↩️'
    
    'Local SEO'             = '📍'
    'Customer Interaction'  = '💬'
    'Insights'              = '📈'
    'Post Updates'          = '📢'
    
    'Cross-Platform'        = '🌐'
    'AI Optimization'       = '🤖'
    'Real-Time Analytics'   = '📊'
    'Budget Control'        = '💰'
    
    '24/7 Availability'     = '🌙'
    'Lead Capture'          = '🧲'
    'Instant Answers'       = '⚡'
    'Human Handoff'         = '🤝'
    
    'Dynamic Codes'         = '🔄'
    'Custom Design'         = '🎨'
    'Tracking & Analytics'  = '📊'
    'Touchless Interaction' = '👋'
}

$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    # Read as UTF8
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # 1. Global Replacements with Regex
    foreach ($key in $GlobalMap.Keys) {
        $val = $GlobalMap[$key]
        $content = $content -replace $key, $val
    }
    
    # 2. Context Icon Replacements
    # Logic: Find <div class="icon">??</div> followed by <h3>Title</h3>
    # Regex: (?s)<div class="icon">\?+<\/div>\s*<h3>(.*?)<\/h3>
    
    # We loop through known titles and replace specific patterns
    foreach ($title in $IconMap.Keys) {
        $icon = $IconMap[$title]
        # Regex to find the broken icon before THIS title
        # match ?? or ? inside div
        $pattern = '(?s)<div class="icon">\?+</div>(\s*<h3>' + [Regex]::Escape($title) + '</h3>)'
        
        if ($content -match $pattern) {
            $replacement = "<div class=`"icon`">$icon</div>`$1"
            $content = $content -replace $pattern, $replacement
        }
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "Restored icons in $($file.Name)"
    }
}
