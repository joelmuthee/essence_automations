$files = @(
    "reputation-management.html",
    "qr-codes.html",
    "gmb-manager.html",
    "documents.html",
    "email-marketing.html",
    "crm-mobile.html",
    "ai-chat.html",
    "ads-manager.html",
    "sms-marketing.html",
    "websites.html",
    "online-calendar.html"
)

Write-Host "File                           | Count | Needs Fix"
Write-Host "--------------------------------------------------"

foreach ($file in $files) {
    if (-not (Test-Path $file)) { continue }
    
    $content = Get-Content -Path $file -Raw -Encoding UTF8
    
    # Simple regex to find the two-column-grid section
    # Matches <div class="grid-container two-column-grid"> ... </div> (roughly)
    # We'll just extract the cards
    
    # 1. Capture the content inside grid-container two-column-grid
    # This is tricky with Regex alone if nested divs exist, but let's try to match the *start* 
    # and infer the block or just count cards if they are unique to this section?
    # Actually, most pages only have ONE two-column-grid section for features.
    
    # Let's count occurrences of <div class="card... inside the file? 
    # NO, some pages might have other cards. 
    # Let's try to isolate the section.
    
    if ($content -match '(?s)<div class="grid-container two-column-grid">(.*?)<\/section>') {
        $gridSection = $matches[1]
        
        # Count cards in this section
        $cards = [Regex]::Matches($gridSection, '<div class="card[^"]*"').Count
        
        $needsFix = ($cards % 2 -ne 0)
        
        # Check if already fixed (simple check for inline style on the word "card")
        # A bit hacky but if the last card has "grid-column: span 2", we are good.
        if ($needsFix) {
            # Get the last card match and check context? 
            # Simpler: Check if the file contains the center alignment string we use
            if ($gridSection -match 'grid-column:\s*span 2') {
                $needsFix = $false
            }
        }
        
        Write-Host ("{0,-30} | {1,-5} | {2}" -f $file, $cards, $needsFix)
    }
    else {
        Write-Host ("{0,-30} | {1,-5} | {2}" -f $file, "N/A", "No Grid")
    }
}
