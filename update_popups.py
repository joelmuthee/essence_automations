import os
import re

files_to_update = [
    "ai-chat.html",
    "ads-manager.html",
    "documents.html",
    "crm.html",
    "email-marketing.html",
    "reputation-management.html",
    "social-planner.html",
    "online-calendar.html",
    "gmb-manager.html",
    "websites.html",
    "whatsapp-marketing.html"
]

# The "Nuclear Solution" Template
# {FORM_ID} and {FORM_NAME} will be replaced
template = """<div id="services-needed-popup" class="conditional-content hidden zoom-in" 
     style="position: fixed !important; inset: 0 !important; width: 100vw !important; height: 100vh !important; background: rgba(0, 0, 0, 0.95) !important; z-index: 2147483647 !important; margin: 0 !important; padding: 0 !important; max-width: none !important; max-height: none !important; overflow: hidden !important; display: none;">
    
    <!-- Flex Container for Centering -->
    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center;">
        
        <!-- Form Container (Full Screen with Scroll) -->
        <div style="position: relative; width: 100%; height: 100%; background: transparent; overflow-y: auto !important; -webkit-overflow-scrolling: touch;">
            
            <!-- Close Button (Fixed relative to viewport) -->
            <button class="close-form-btn" onclick="this.closest('#services-needed-popup').classList.add('hidden'); this.closest('#services-needed-popup').style.display='none';" title="Close Form"
                style="background: #ff6b00 !important; color: white; position: fixed; top: 20px; right: 20px; border-radius: 50%; width: 50px; height: 50px; font-size: 30px; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 10px rgba(0,0,0,0.5); border: none; cursor: pointer; z-index: 2147483647;">&times;</button>
            
            <!-- Iframe (Corrected Style - Forced Visible & INLINE layout) -->
            <iframe src="https://link.essenceautomations.com/widget/form/{FORM_ID}"
                style="width: 100%; height: 100%; min-height: 100vh; border: none; display: block !important;"
                id="popup-{FORM_ID}" data-layout="{'id':'INLINE'}" data-trigger-type="alwaysShow"
                data-trigger-value="" data-activation-type="alwaysActivated" data-activation-value=""
                data-deactivation-type="neverDeactivate" data-deactivation-value=""
                data-form-name="{FORM_NAME}" data-height="504"
                data-layout-iframe-id="popup-{FORM_ID}" data-form-id="{FORM_ID}"
                title="{FORM_NAME}" scrolling="no">
            </iframe>
        </div>
    </div>
    
    <script src="https://link.essenceautomations.com/js/form_embed.js"></script>
</div>"""

def update_file(filename):
    file_path = os.path.abspath(filename)
    if not os.path.exists(file_path):
        print(f"File not found: {filename}")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to find the existing popup div
    # Matches <div id="services-needed-popup" ... up to the closing </div> tag of the outer div
    # Using a greedy match with careful lookahead or checking for balanced tags is hard with regex.
    # However, these files usually have this structure at the end.
    # Let's verify if we can find the data-form-id and data-form-name first.
    
    id_match = re.search(r'data-form-id="([^"]+)"', content)
    name_match = re.search(r'data-form-name="([^"]+)"', content)
    
    # We need to ensure we are capturing the ID/Name from the 'services-needed-popup' block specifically
    # but practically these files usually only have ONE such form (except rate-us which we excluded).
    
    if not id_match or not name_match:
        print(f"Skipping {filename}: Could not find form ID or Name.")
        # Try to print snippet to debug
        snippet = re.search(r'<div id="services-needed-popup".*?</div>', content, re.DOTALL)
        if snippet:
            print(f"Found div but no ID match in: {snippet.group(0)[:100]}...")
        return

    form_id = id_match.group(1)
    form_name = name_match.group(1)
    
    print(f"Updating {filename} (ID: {form_id}, Name: {form_name})...")

    # Construct new popup html
    new_popup = template.replace("{FORM_ID}", form_id).replace("{FORM_NAME}", form_name)

    # Replace the old popup
    # We'll use a regex that matches from <div id="services-needed-popup" to the script tag usually inside or after it?
    # The current implementations vary slightly.
    # Safe approach: Find Start Index of <div id="services-needed-popup"
    # Find the closing </div> corresponding to it. 
    # Since checking for balanced divs is hard, and we know these come right before </body> usually, 
    # we can try to match from <div id="services-needed-popup" ... until </body> and just replace the div part.
    
    # Better: Match specifically the known structure if possible.
    # Most look like:
    # <div id="services-needed-popup" ...>
    #    ... content ...
    # </div>
    # followed by </body> or EOF
    
    # Regex: <div id="services-needed-popup"[\s\S]*?<\/div>\s*(?=<\/body>|<!-- End|$)
    # Note: The embedded form script is often INSIDE the div. 
    # The closing div is usually the last thing.
    
    # Let's try locating the start content and finding the </script></div> sequence which closes it in the old version (usually).
    
    start_marker = '<div id="services-needed-popup"'
    start_pos = content.find(start_marker)
    
    if start_pos == -1:
        print(f"Could not find start of popup div in {filename}")
        return
        
    # Heuristic: The popup usually contains form_embed.js script. 
    # Current structure usually ends with: <script ... form_embed.js"></script></div>
    # or </div> followed by script.
    
    # Let's try to match the whole block roughly.
    # We will assume the block ends at the instance of `</div>` that follows the form_embed.js script.
    
    embed_script = 'form_embed.js"></script>'
    embed_pos = content.find(embed_script, start_pos)
    
    if embed_pos == -1:
        print(f"Could not find form_embed.js in popup of {filename}")
        # fallback for old versions without script inside?
        # Use regex to find next </div> which should be close
        return

    end_div_pos = content.find('</div>', embed_pos)
    if end_div_pos == -1:
         print(f"Could not find closing div in {filename}")
         return
         
    # Include the </div> (len('</div>') is 6)
    end_pos = end_div_pos + 6
    
    # Validation: Print what we are replacing to be safe (first 100 chars and last 100)
    old_block = content[start_pos:end_pos]
    # print(f"Replacing block:\n{old_block[:100]} ... {old_block[-50:]}")
    
    new_content = content[:start_pos] + new_popup + content[end_pos:]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
        
    print(f"Successfully updated {filename}")

for file in files_to_update:
    try:
        update_file(file)
    except Exception as e:
        print(f"Error updating {file}: {e}")
