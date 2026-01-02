import glob
import re
import os

def reorder_block(content, pattern_start, pattern_end, item_pattern, target_after_pattern):
    # This is a bit complex to do generically with different indentations.
    # Let's try a specific approach for the known structure.
    # We want to move the line containing "ai-chat.html" to be after the line containing "websites.html"
    
    # Split into lines
    lines = content.split('\n')
    new_lines = []
    
    # We will process closely related blocks.
    # Identify the block of links in Navbar and Footer.
    
    # Easier strategy: Read the file, identify the lines for websites.html and ai-chat.html within specific sections.
    
    # Let's use string manipulation on the specific lists.
    # Navbar: <div class="dropdown-content glass-effect"> ... </div>
    # Footer: <div class="footer-column"> ... <h4>Services</h4> ... </div>
    
    # Regex to find the container could be safer.
    
    return content

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 1. Navbar Reorder
    # Look for the dropdown content block
    # Structure:
    # <div class="dropdown-content glass-effect">
    #    ... links ...
    # </div>
    
    # We'll use a regex to grab the inner content of the dropdown
    nav_pattern = re.compile(r'(<div class="dropdown-content glass-effect">)(.*?)(</div>)', re.DOTALL)
    
    def reorder_links(match):
        header = match.group(1)
        body = match.group(2)
        footer = match.group(3)
        
        # Extract links
        # Assuming one link per line or separated clearly? 
        # In the file view, they are on separate lines, but indentation varies.
        # Let's verify if we can split by <a href
        
        links = re.findall(r'<a href="[^"]+">.*?</a>', body) 
        # This ignores whitespaces between tags, which we might want to preserve or just reconstruct.
        # Reconstructing is safer for order, might lose custom indentation but that's okay (or we can standardise).
        # Let's capture the formatting (whitespace) before the tag if possible? 
        # Actually, let's just find the specific lines and swap.
        
        if not links:
            return match.group(0) # No links found?
            
        # Find ai-chat and websites
        ai_chat_idx = -1
        websites_idx = -1
        
        for i, link in enumerate(links):
            if 'ai-chat.html' in link:
                ai_chat_idx = i
            if 'websites.html' in link:
                websites_idx = i
                
        if ai_chat_idx != -1 and websites_idx != -1:
            # Pop ai chat
            ai_chat_link = links.pop(ai_chat_idx)
            # Re-calculate websites_idx if ai_chat was before it (unlikely given request, but possible)
            if ai_chat_idx < websites_idx:
                websites_idx -= 1
            
            # Insert after websites
            links.insert(websites_idx + 1, ai_chat_link)
            
            # Reconstruct body
            # We will just join them with newlines and standard indentation to look clean.
            # Or try to preserve original surrounding whitespace? 
            # The original body has newlines and spaces. 
            # Simple approach: Split body by <a, capture the separator? Hard.
            
            # Let's just create a standard block.
            new_body = "\n"
            for link in links:
                new_body += f"                        {link}\n"
            new_body += "                    "
            
            return f"{header}{new_body}{footer}"
        
        return match.group(0)

    content = nav_pattern.sub(reorder_links, content)
    
    # 2. Footer Reorder
    # <div class="footer-column">
    #    <h4>Services</h4>
    #    ... links ...
    # </div>
    
    footer_pattern = re.compile(r'(<h4>Services</h4>)(.*?)(</div>)', re.DOTALL)
    
    def reorder_footer_links(match):
        header = match.group(1) # <h4>Services</h4>
        body = match.group(2)
        footer = match.group(3) # </div>
        
        links = re.findall(r'<a href="[^"]+">.*?</a>', body)
        
        ai_chat_idx = -1
        websites_idx = -1
        
        for i, link in enumerate(links):
            if 'ai-chat.html' in link:
                ai_chat_idx = i
            if 'websites.html' in link:
                websites_idx = i
                
        if ai_chat_idx != -1 and websites_idx != -1:
            ai_chat_link = links.pop(ai_chat_idx)
            if ai_chat_idx < websites_idx:
                websites_idx -= 1
            links.insert(websites_idx + 1, ai_chat_link)
            
            new_body = "\n\n" # A bit of spacing after header
            for link in links:
                new_body += f"                        {link}\n"
            new_body += "                    "
            
            return f"{header}{new_body}{footer}"
        return match.group(0)

    content = footer_pattern.sub(reorder_footer_links, content)

    # 3. Ecosystem Reorder (Only for index.html)
    if 'index.html' in filepath:
        # Structure: <div class="grid-container"> ... cards ... </div>
        # Cards are <div class="card ..."> ... </div>
        # This is nested. Regex might be brittle for nested divs if not careful.
        # But the cards are top level inside grid-container.
        
        # Let's identify the grid-container block
        grid_start = content.find('<div class="grid-container">')
        if grid_start != -1:
            # Find the closing div for this container. 
            # Doing a simple balance check
            idx = grid_start + len('<div class="grid-container">')
            balance = 1
            while idx < len(content) and balance > 0:
                if content[idx:idx+4] == '<div':
                    balance += 1
                    idx += 4
                elif content[idx:idx+5] == '</div':
                    balance -= 1
                    idx += 5
                else:
                    idx += 1
            
            grid_content_full = content[grid_start:idx]
            inner_content = grid_content_full[len('<div class="grid-container">'):-6] # strip outer div
            
            # Split into cards. 
            # Cards start with <div class="card
            # We can use regex to split, or findall.
            # Since cards contain divs (icon), we need to balance them too.
            
            cards = []
            curr_pos = 0
            while True:
                card_start = inner_content.find('<div class="card', curr_pos)
                if card_start == -1:
                    break
                
                # Find end of this card
                c_idx = card_start + len('<div class="card')
                c_balance = 1
                while c_idx < len(inner_content) and c_balance > 0:
                    if inner_content[c_idx:c_idx+4] == '<div':
                        c_balance += 1
                        c_idx += 4
                    elif inner_content[c_idx:c_idx+5] == '</div':
                        c_balance -= 1
                        c_idx += 5
                    else:
                        c_idx += 1
                
                cards.append(inner_content[card_start:c_idx])
                curr_pos = c_idx
            
            # Now reorder cards
            ai_chat_card = None
            websites_card = None
            ai_chat_idx = -1
            websites_idx = -1
            
            for i, card in enumerate(cards):
                if 'ai-chat.html' in card:
                    ai_chat_card = card
                    ai_chat_idx = i
                if 'websites.html' in card:
                    websites_card = card
                    websites_idx = i
            
            if ai_chat_idx != -1 and websites_idx != -1:
                cards.pop(ai_chat_idx)
                if ai_chat_idx < websites_idx:
                    websites_idx -= 1
                cards.insert(websites_idx + 1, ai_chat_card)
                
                # Reconstruct grid
                new_inner = "\n" + "\n".join(cards) + "\n            "
                new_grid = f'<div class="grid-container">{new_inner}</div>'
                
                content = content.replace(grid_content_full, new_grid)

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filepath}")
    else:
        print(f"No changes for {filepath}")

# Process all html files
files = glob.glob("*.html")
for file in files:
    process_file(file)
