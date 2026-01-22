import os
import re

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # 1. Remove inline style from h3 inside stat-card
    # Looking for: style="font-size: 2.5rem; margin-bottom: 0;"
    # Regex to be safe with spacing
    content = re.sub(r'(<h3[^>]*?class="[^"]*?gradient-text[^"]*?")\s+style="[^"]*?font-size:\s*2\.5rem[^"]*?"', r'\1', content)
    
    # 2. Remove inline style from grid-container
    # Looking for: style="gap: 1.5rem;" or similar
    content = re.sub(r'(<div[^>]*?class="[^"]*?grid-container[^"]*?")\s+style="[^"]*?gap:\s*1\.5rem;[^"]*?"', r'\1', content)

    # 3. Clean up stats-section inline style if specific match
    # <section class="stats-section" style="padding: 2rem 5%; text-align: center;">
    content = re.sub(r'(<section[^>]*?class="[^"]*?stats-section[^"]*?")\s+style="[^"]*?padding:\s*2rem\s+5%;[^"]*?"', r'\1', content)

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {os.path.basename(filepath)}")
    else:
        print(f"No changes in {os.path.basename(filepath)}")

for filename in os.listdir(directory):
    if filename.endswith(".html"):
        process_file(os.path.join(directory, filename))
