
import os
import re

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# Files to CLEAN (remove the section from)
# Exclude reputation-management.html
files_to_clean = [
    "websites.html",
    "social-planner.html",
    "sms-marketing.html",
    "online-calendar.html",
    "index.html",
    "gmb-manager.html",
    "faq.html",
    "email-marketing.html",
    "documents.html",
    "crm.html",
    "ai-chat.html",
    "ads-manager.html",
    "about.html",
    "qr-codes.html",
    "reference_site.html",
    "rate-us.html" # User said "only on Reviews webpage", so removing from here too unless it looks different
]

def remove_section(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Regex to find the feedback system section
    # We look for <section id="feedback-system" ... </section>
    # Utilizing DOTALL to match across lines, and non-greedy matching
    
    # Pattern:
    # <section id="feedback-system" ...>
    # ... content ...
    # </section>
    
    # Note: Regex parsing HTML is risky if nested sections exist. 
    # But this section is likely top-level within <main>.
    # We'll be careful.
    
    pattern = r'(<section[^>]*id="feedback-system"[^>]*>.*?</section>)'
    
    # Check if exists
    match = re.search(pattern, content, re.DOTALL)
    if match:
        print(f"Removing feedback-system from {os.path.basename(filepath)}")
        # Replace with empty string
        new_content = content.replace(match.group(1), "")
        
        # Cleanup extra newlines if any (optional, but nice)
        # Using simple string replace might leave a gap.
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
    else:
        print(f"Section not found in {os.path.basename(filepath)}")

for filename in files_to_clean:
    filepath = os.path.join(directory, filename)
    if os.path.exists(filepath):
        remove_section(filepath)
    else:
        print(f"File not found: {filename}")

