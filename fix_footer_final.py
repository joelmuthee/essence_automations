import os
import re

files_to_update = [
    "index.html",
    "email-marketing.html",
    "documents.html",
    "crm-mobile.html",
    "ai-chat.html",
    "ads-manager.html",
    "about.html",
    "gmb-manager.html",
    "reputation-management.html",
    "sms-marketing.html",
    "social-planner.html",
    "websites.html",
    "qr-codes.html",
    "online-calendar.html",
    "faq.html",
    "rate-us.html" # Added this just in case
]

base_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# The correct footer brand block with SVGs
correct_block = """                <div class="footer-brand">
                    <div class="brand">
                        <img src="essence-logo-full.png" alt="Essence Automations" class="footer-logo">
                    </div>
                    <div class="contact-info">
                        <a href="tel:+254720615606">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-telephone-fill" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M1.885.511a1.745 1.745 0 0 1 2.61.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.678.678 0 0 0 .178.643l2.457 2.457a.68.68 0 0 0 .644.178l2.189-.547a1.745 1.745 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.634 18.634 0 0 1-7.01-4.42 18.634 18.634 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877L1.885.511z"/>
                            </svg>
                            +254 720 615 606
                        </a>
                        <a href="mailto:chat@essenceautomations.com">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-envelope-fill" viewBox="0 0 16 16">
                                <path d="M.05 3.555A2 2 0 0 1 2 2h12a2 2 0 0 1 1.95 1.555L8 8.414.05 3.555zM0 4.697v7.104l5.803-3.558L0 4.697zM6.761 8.83l-6.57 4.027A2 2 0 0 0 2 14h12a2 2 0 0 0 1.808-1.144l-6.57-4.027L8 9.586l-1.239-.757zm3.436-.586L16 11.801V4.697l-5.803 3.546z"/>
                            </svg>
                            chat@essenceautomations.com
                        </a>
                    </div>
                </div>"""

# Regex pattern to match the footer-brand div and its content loosely
# This tries to catch:
# 1. <div class="footer-brand">
# 2. Any content inside (including the garbled stuff)
# 3. Up to the closing </div> of the contact-info, plus the closing </div> of footer-brand
# We rely on the structure: footer-brand > brand + contact-info
pattern = re.compile(
    r'<div class="footer-brand">\s*<div class="brand">.*?</div>\s*<div class="contact-info">.*?</div>\s*</div>',
    re.DOTALL
)

count_updated = 0

for filename in files_to_update:
    filepath = os.path.join(base_dir, filename)
    if not os.path.exists(filepath):
        print(f"Skipping {filename}: not found")
        continue
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Check if replacement is needed (i.e., doesn't already have the full SVG block)
        # Simple check: if it has the svg definition we might be good, 
        # but let's force replace to be sure alignment/spaces are uniform using our block.
        
        new_content = pattern.sub(correct_block, content)
        
        if new_content != content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Updated {filename}")
            count_updated += 1
        else:
            print(f"No changes needed for {filename} (or pattern match failed)")
            # Fallback debug: print a snippet if match failed but file seems to need update
            if "footer-brand" in content and "bi-telephone-fill" not in content:
                 print(f"WARNING: Match failed for {filename} but it seems to lack SVGs.")
                 # Inspecting structure
                 match = re.search(r'<div class="footer-brand">', content)
                 if match:
                     start = match.start()
                     print(f"Snippet: {content[start:start+300]}...")

    except Exception as e:
        print(f"Error processing {filename}: {e}")

print(f"Total files updated: {count_updated}")
