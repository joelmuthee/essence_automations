import os
import re

# Logic:
# 1. Add "Demos" to Header Nav (after Rate Us)
# 2. Add "Demos" to Footer Nav (after Rate Us)
# 3. For SERVICE pages: Remove Calendar Iframe and Start Your Project Header -> Replace with "Start Your Build" + Button.
# 4. Inject Popup HTML.

root_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# Map filename to Service Name for the form
service_map = {
    "websites.html": "Ultra-modern Websites", # Already done manually, but script can verify
    "ai-chat.html": "AI Support Chat",
    "gmb-manager.html": "GBP Booster",
    "crm-mobile.html": "CRM & Mobile App",
    "ads-manager.html": "AI Ads Manager",
    "reputation-management.html": "Google Reviews", # Already done manually
    "sms-marketing.html": "SMS Marketing",
    "email-marketing.html": "Email Marketing",
    "online-calendar.html": "Online Appointment Calendar",
    "documents.html": "Document Management",
    "social-planner.html": "Social Media Management",
    "qr-codes.html": "QR Codes"
}

# The popup HTML block to inject
popup_html = """
        <!-- Services Needed Form (Pop-up/Inline) -->
        <div id="services-needed-popup" class="conditional-content hidden">
            <button class="close-form-btn" onclick="this.parentElement.classList.add('hidden');"
                title="Close Form">&times;</button>
            <iframe
                src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={service_encoded}"
                style="display:none;width:100%;height:100%;border:none;border-radius:4px"
                id="popup-g9F8xoEZgZjMUDIIP6hN" data-layout='{{"id":"INLINE"}}' data-trigger-type="alwaysShow"
                data-trigger-value="" data-activation-type="alwaysActivated" data-activation-value=""
                data-deactivation-type="neverDeactivate" data-deactivation-value=""
                data-form-name="Services Needed Form" data-height="849"
                data-layout-iframe-id="popup-g9F8xoEZgZjMUDIIP6hN" data-form-id="g9F8xoEZgZjMUDIIP6hN"
                title="Services Needed Form">
            </iframe>
            <script src="https://link.essenceautomations.com/js/form_embed.js"></script>
        </div>
"""

# Template for the new CTA section content (replacing what's inside <section id="contact">)
# Note: usage of {service_name} variable
cta_section_content = """
            <div class="section-header">
                <h2 class="fade-in-up">Interested in {service_name}?</h2>
                <p>Let us know and we'll send you more details.</p>
                <div style="margin-top: 2rem;">
                    <button onclick="showServicesPopup('{service_name}')" class="btn-primary"
                        style="border:none; cursor:pointer; font-family: inherit; font-size: 1rem;">I'm Interested</button>
                </div>
            </div>
"""

import urllib.parse

def process_file(filepath, filename):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    modified = False

    # 1. Add Demos to Header
    # Look for <li><a href="rate-us.html">Rate Us</a></li>
    # Add <li><a href="demos.html">Demos</a></li> after it if not present
    if 'href="demos.html"' not in content and 'href="rate-us.html"' in content:
        # Header Nav
        content = content.replace(
            '<li><a href="rate-us.html">Rate Us</a></li>',
            '<li><a href="rate-us.html">Rate Us</a></li>\n                <li><a href="demos.html">Demos</a></li>'
        )
        modified = True

    # 2. Add Demos to Footer
    # Look for <a href="rate-us.html">Rate Us</a> in footer (often inside footer-column)
    # Using specific check for footer column context or just regex match after
    if '<a href="demos.html">Demos</a>' not in content and '<a href="rate-us.html">Rate Us</a>' in content:
         # To avoid double replacement if header one was same string (unlikely due to <li> wrapper),
         # but let's be safe. The header one has <li>, footer one doesn't.
         # Replaces instances NOT wrapped in <li>
         # Actually simple string replace works because header one is now changed.
         # So we look for the remaining one.
         content = content.replace(
            '<a href="rate-us.html">Rate Us</a>',
            '<a href="rate-us.html">Rate Us</a>\n                        <a href="demos.html">Demos</a>'
         )
         modified = True

    # 3. Swap CTA on Service Pages
    if filename in service_map:
        service_name = service_map[filename]
        service_encoded = urllib.parse.quote(service_name)
        
        # Identify the Contact/Calendar Section.
        # Usually: <section id="contact" class="contact"> ... <iframe ... booking ...> ... </section>
        # We want to keep the <section> wrapper but replace inner HTML.
        
        # Regex to find the calendar section content.
        # It usually contains "Book a Demo" or "Start Your Project" and the booking iframe.
        # We'll match loosely.
        
        booking_iframe_pattern = r'(<div class="section-header">.*?<h2.*?>.*?</h2>.*?</div>\s*<div class="calendar-container.*?">.*?<iframe.*?booking/oO6WgghbYEmmjvXHx8fK.*?</iframe>.*?</div>)'
        
        match = re.search(booking_iframe_pattern, content, re.DOTALL)
        if match:
            print(f"[{filename}] Found Calendar Section. Replacing...")
            # Prepare new content
            new_content = cta_section_content.format(service_name=service_name)
            
            # Perform replacement
            content = content.replace(match.group(1), new_content)
            modified = True
            
            # 4. Inject Popup HTML
            # Check if popup already exists
            if 'id="services-needed-popup"' not in content:
                print(f"[{filename}] Injecting Popup HTML...")
                # Inject before </section> of the contact section if possible, 
                # OR just append to the new content we just inserted.
                # Actually, simpler to append it to the new_content, BUT
                # the match was just the inner part.
                
                # Let's verify where to inject. The popup often lives inside the section or just after.
                # In websites.html I put it inside the section.
                # So let's replace the match with (New Content + Popup HTML).
                
                final_popup_html = popup_html.format(service_encoded=service_encoded)
                replacement_block = new_content + "\n" + final_popup_html
                
                # Re-do replacement with popup included
                content = content.replace(new_content, replacement_block) 

    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {filename}")
    else:
        print(f"No changes for {filename}")

# Main loop
for filename in os.listdir(root_dir):
    if filename.endswith(".html") and filename != "demos.html": # Skip demos.html to keep calendar there!
        process_file(os.path.join(root_dir, filename), filename)
