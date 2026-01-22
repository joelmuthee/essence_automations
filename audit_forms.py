
import os
import re

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

print(f"{'File':<30} | {'Inline Min-Height':<20} | {'Data-Height':<15} | {'Status'}")
print("-" * 80)

for filename in os.listdir(directory):
    if filename.endswith(".html"):
        filepath = os.path.join(directory, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Find conditional-content divs
        # <div ... class="conditional-content ..." style="...">
        # We need to capture the style attribute if it exists, and the enclosed iframe's data-height
        
        # Simple regex to find the div start
        div_matches = re.finditer(r'<div[^>]*?class="[^"]*?conditional-content[^"]*?"([^>]*)>', content)
        
        for match in div_matches:
            attrs = match.group(1)
            
            # Extract inline style min-height
            style_match = re.search(r'style="[^"]*?min-height:\s*(\d+)px', attrs)
            inline_height = style_match.group(1) if style_match else "None"
            
            # Look ahead for data-height in the next few lines (hacky but works for this structure)
            start_pos = match.end()
            chunk = content[start_pos:start_pos+1000] # reasonable chunk
            height_match = re.search(r'data-height="(\d+)"', chunk)
            data_height = height_match.group(1) if height_match else "Unknown"
            
            status = "OK (CSS Controlled)"
            if inline_height != "None":
                status = "Inline Style Active"
                if abs(int(inline_height) - int(data_height)) > 50:
                     status = f"MISMATCH ({int(inline_height)} vs {data_height})"

            print(f"{filename:<30} | {inline_height:<20} | {data_height:<15} | {status}")
