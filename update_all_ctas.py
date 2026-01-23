import os
import urllib.parse

# Mapping of file names to checkbox values
# Values must match EXACTLY what is on the GHL form (case sensitive)
SERVICE_MAPPING = {
    "websites.html": "Ultra-modern Websites",
    "ai-chat.html": "AI Support Chat",
    "gmb-manager.html": "GBP Booster",
    "crm.html": "CRM & Mobile App",
    "ads-manager.html": "AI Ads Manager",
    "reputation-management.html": "Google Reviews", # Already done, but good to have in list
    "sms-marketing.html": "SMS Marketing",
    "email-marketing.html": "Email Marketing",
    "online-calendar.html": "Appointment Calendar",
    "documents.html": "Document Management",
    "social-planner.html": "Social Media Management",
    "qr-codes.html": "QR Codes"
}

# The template for the popup
POPUP_TEMPLATE = """
            <!-- Services Needed Form (Pop-up/Inline) -->
            <div id="services-needed-popup" class="conditional-content hidden"
                style="min-height: 849px; max-width: 800px; margin: 2rem auto 0 auto;">
                <button class="close-form-btn" onclick="this.parentElement.classList.add('hidden');"
                    title="Close Form">&times;</button>
                <iframe src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={encoded_value}"
                    style="display:none;width:100%;height:100%;border:none;border-radius:4px"
                    id="popup-g9F8xoEZgZjMUDIIP6hN" data-layout="{{'id':'POPUP'}}" data-trigger-type="alwaysShow"
                    data-trigger-value="" data-activation-type="alwaysActivated" data-activation-value=""
                    data-deactivation-type="neverDeactivate" data-deactivation-value=""
                    data-form-name="Services Needed Form" data-height="849"
                    data-layout-iframe-id="popup-g9F8xoEZgZjMUDIIP6hN" data-form-id="g9F8xoEZgZjMUDIIP6hN"
                    title="Services Needed Form">
                </iframe>
                <script src="https://link.essenceautomations.com/js/form_embed.js"></script>
            </div>
"""

def update_file(filename, service_value):
    if not os.path.exists(filename):
        print(f"Skipping {filename} (not found)")
        return

    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()

    # Skip reputation-management.html as it is already manually done and might key off this log logic
    if filename == "reputation-management.html":
        # Just ensure it has the correct new encoded value if we wanted to enforce it, 
        # but let's skip to avoid overwriting custom work unless necessary.
        # Actually proper standardisation is good. Let's process it but be careful.
        # The user said "intelligently apply this to ALL".
        # Let's check if the popup already exists.
        pass

    # 1. Check if "Want This On Your Site?" section exists
    search_str = "Want This On Your Site?"
    if search_str not in content:
        print(f"Skipping {filename} (CTA section not found)")
        return

    encoded_value = urllib.parse.quote(service_value)
    
    # 2. Check if already updated (has the popup ID or onclick)
    if "services-needed-popup" in content:
        print(f"Updating existing popup in {filename}")
        # Identify the iframe src line and replace it
        import re
        # Regex to find the iframe src attribute within the popup
        # This is a bit risky with regex on HTML but for this specific update it should be fine
        # creating a new src string
        new_src = f'src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={encoded_value}"'
        
        # We need to find the specific iframe inside the specific div.
        # Let's do a more string-based approach if possible or regex replace.
        # Searching for the specific existing src parameter pattern
        pattern = r'src="https:\/\/link\.essenceautomations\.com\/widget\/form\/g9F8xoEZgZjMUDIIP6hN[^"]*"'
        
        # Find all matches, we want the one inside the popup.
        # Assuming there is only one such form per page or we target the one near the CTA.
        # simpler: The popup template uses "services-needed-popup"
        # We can reconstruct the file content.
        pass
    
    # NEW STRATEGY:
    # Find the CTA Button and replace it.
    # Find the closing </section> of the CTA section and insert the popup before it.
    
    # Look for the button: usually <a href="index.html#contact" class="btn-primary">Get It Now</a>
    # OR <a href="#contact" class="btn-primary">Get It Now</a>
    # OR the new button <button ...>Get It Now</button>
    
    # Helper to find the section
    start_marker = '<section class="contact"'
    if 'id="contact"' in content and filename != "index.html": 
         # Some pages might have id="contact" on this section
         pass

    # Let's rely on the text "Want This On Your Site?" to locate the block.
    # We will look for the button immediately following it.
    
    # Standard Button Code (Old)
    old_button_1 = '<a href="index.html#contact" class="btn-primary">Get It Now</a>'
    old_button_2 = '<a href="#contact" class="btn-primary">Get It Now</a>'
    
    # New Button Code
    new_button = """<button onclick="document.getElementById('services-needed-popup').classList.remove('hidden');"
                        class="btn-primary" style="border:none; cursor:pointer; font-family: inherit; font-size: 1rem;">Get It Now</button>"""

    # We also need to remove the extra div wrapper if we added one before or keep it clean.
    # The original was:
    # <div style="margin-top: 2rem;">
    #    <a ...>Get It Now</a>
    # </div>
    
    # Let's do a replace on the button first.
    if old_button_1 in content:
        content = content.replace(old_button_1, new_button)
        print(f"Replaced button type 1 in {filename}")
    elif old_button_2 in content:
        content = content.replace(old_button_2, new_button)
        print(f"Replaced button type 2 in {filename}")
    elif "onclick=\"document.getElementById('services-needed-popup')" in content:
         print(f"Button already updated in {filename}")
    else:
        print(f"Could not find exact button match in {filename}, manual check needed.")
        # Try finding "Get It Now"
        pass

    # Now insert the popup if it's not there
    if 'id="services-needed-popup"' not in content:
        # Find the closing tag of the section containing "Want This On Your Site?"
        # We can look for the string "Want This On Your Site?" and then find the next </section>
        idx = content.find("Want This On Your Site?")
        if idx != -1:
            section_end_idx = content.find("</section>", idx)
            if section_end_idx != -1:
                # Insert before </section>
                popup_code = POPUP_TEMPLATE.format(encoded_value=encoded_value)
                content = content[:section_end_idx] + popup_code + content[section_end_idx:]
                print(f"Inserted popup in {filename}")
            else:
                print(f"Could not find closing section tag in {filename}")
    
    else:
        # Popup exists, update the URL
        # We need to ensure the URL has the correct service value
        import re
        # Find the iframe source within the popup
        popup_start = content.find('id="services-needed-popup"')
        popup_end = content.find('</div>', popup_start) # dangerous if nested divs, but our template is simple
        # Better: find the specific iframe data-form-id="g9F8xoEZgZjMUDIIP6hN"
        
        # Regex replacement for the specific src url
        # src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?..."
        
        target_src_start = 'src="https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN'
        # We assume the src attribute ends with "
        
        # This is global replace, but specific enough URL
        # We replace the entire SRC attribute with the new one
        
        # Regex: src="https:\/\/link\.essenceautomations\.com\/widget\/form\/g9F8xoEZgZjMUDIIP6hN[^"]*"
        new_src_url = f'https://link.essenceautomations.com/widget/form/g9F8xoEZgZjMUDIIP6hN?services_needed={encoded_value}'
        
        content = re.sub(
            r'src="https:\/\/link\.essenceautomations\.com\/widget\/form\/g9F8xoEZgZjMUDIIP6hN[^"]*"',
            f'src="{new_src_url}"',
            content
        )
        print(f"Updated iframe URL in {filename}")

    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)

def main():
    for filename, service_value in SERVICE_MAPPING.items():
        print(f"Processing {filename}...")
        try:
            update_file(filename, service_value)
        except Exception as e:
            print(f"Error processing {filename}: {e}")

if __name__ == "__main__":
    main()

