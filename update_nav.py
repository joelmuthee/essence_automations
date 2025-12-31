import os
import re

files_to_update = [
    "about.html",
    "ai-chat.html",
    "crm-mobile.html",
    "email-marketing.html",
    "gmb-manager.html",
    "online-calendar.html",
    "reputation-management.html",
    "sms-marketing.html",
    "social-planner.html",
    "websites.html"
]

base_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Test"

nav_pattern = r'(<a href="ai-chat.html">AI Chat</a>\s+)(<a href="online-calendar.html">Online Calendar</a>\s+)(<a href="gmb-manager.html">GMB Manager</a>\s+)(<a href="social-planner.html">Social Planner</a>)'
nav_replacement = r'\1\2<a href="documents.html">Documents</a>\n                        \3\4\n                        <a href="qr-codes.html">QR Codes</a>'

# Footer might vary slightly, let's just target the list of links
footer_pattern = r'(<a href="ai-chat.html">AI Chat</a>\s+)(<a href="online-calendar.html">Online Calendar</a>\s+)(<a href="gmb-manager.html">GMB Manager</a>\s+)(<a href="social-planner.html">Social Planner</a>)'
# Use regex to find the block of links
# Since indentation might vary, we'll try to use a more robust regex or just flexible spacing

for filename in files_to_update:
    filepath = os.path.join(base_dir, filename)
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # We will search for the specific block of links and inject the new ones
    # The block usually looks like:
    # <a href="ai-chat.html">AI Chat</a>
    # <a href="online-calendar.html">Online Calendar</a>
    # <a href="gmb-manager.html">GMB Manager</a>
    # ...
    
    # Let's define the marker lines
    marker_start = '<a href="ai-chat.html">AI Chat</a>'
    marker_end = '<a href="reputation-management.html">Google Reviews</a>'
    
    # New block content
    new_block = '''<a href="ai-chat.html">AI Chat</a>
                        <a href="online-calendar.html">Online Calendar</a>
                        <a href="documents.html">Documents</a>
                        <a href="gmb-manager.html">GMB Manager</a>
                        <a href="social-planner.html">Social Planner</a>
                        <a href="qr-codes.html">QR Codes</a>
                        <a href="reputation-management.html">Google Reviews</a>'''
    
    # We need to replace the section between marker_start and marker_end (inclusive)
    # But wait, there are other links between them.
    # regex: <a href="ai-chat.html">AI Chat</a>[\s\S]*?<a href="reputation-management.html">Google Reviews</a>
    
    regex = r'(<a href="ai-chat\.html">AI Chat</a>[\s\S]*?<a href="reputation-management\.html">Google Reviews</a>)'
    
    # We need to apply this twice because it appears in Header Nav and Footer
    
    def replacer(match):
        # We replace the entire matched block with our constructed block
        # However, we should try to preserve indentation if possible, but hardcoding might be safer for now given the consistency of these files.
        # Based on previous file reads, they look consistent.
        return new_block

    new_content = re.sub(regex, new_block, content)
    
    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filename}")
    else:
        print(f"No changes made to {filename} (Pattern not found?)")

