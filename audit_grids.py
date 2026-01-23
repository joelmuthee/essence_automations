import os
import re

files = [
    "reputation-management.html",
    "qr-codes.html",
    "gmb-manager.html",
    "documents.html",
    "email-marketing.html",
    "crm.html",
    "ai-chat.html",
    "ads-manager.html",
    "sms-marketing.html",
    "websites.html",
    "online-calendar.html"
]

print(f"{'File':<30} | {'Count':<5} | {'Needs Fix':<10}")
print("-" * 50)

for filename in files:
    if not os.path.exists(filename):
        continue
        
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Find the grid
    # specific match for the container
    match_start = re.search(r'<div class="grid-container two-column-grid">', content)
    if not match_start:
        print(f"{filename:<30} | {'N/A':<5} | No Grid")
        continue

    # Extract the block roughly (assuming valid HTML structure until next section or </section>)
    # A bit naive but likely sufficient: look for the closing section or next section
    # Better: Count nested divs to find matching </div>
    
    start_index = match_start.end()
    open_divs = 1
    current_index = start_index
    
    while open_divs > 0 and current_index < len(content):
        # find next <div or </div
        next_open = content.find('<div', current_index)
        next_close = content.find('</div>', current_index)
        
        if next_close == -1: break # Error
        
        if next_open != -1 and next_open < next_close:
            open_divs += 1
            current_index = next_open + 4
        else:
            open_divs -= 1
            current_index = next_close + 6
            
    grid_content = content[start_index:current_index]
    
    # Count cards
    cards = list(re.finditer(r'<div class="card[^"]*"', grid_content))
    count = len(cards)
    
    needs_fix = (count % 2 != 0)
    
    # Check if last card already has the style
    if needs_fix and cards:
        last_card_start = cards[-1].start()
        last_card_tag = grid_content[last_card_start:grid_content.find('>', last_card_start)]
        if "grid-column: span 2" in last_card_tag:
            needs_fix = False # Already fixed
            
    print(f"{filename:<30} | {count:<5} | {needs_fix}")

