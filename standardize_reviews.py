
import os
import re

SOURCE_FILE = 'reputation-management.html'
TARGET_DIR = '.'
SECTION_ID = 'feedback-system'

def get_master_widget():
    """Extracts the feedback-system section from the source file."""
    if not os.path.exists(SOURCE_FILE):
        print(f"Error: Source file {SOURCE_FILE} not found.")
        return None

    with open(SOURCE_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex to capture the section.
    # We look for <section ... id="feedback-system" ... > ... </section>
    # Using dotall to capture newlines.
    pattern = re.compile(r'(<section[^>]*id=["\']feedback-system["\'][^>]*>.*?</section>)', re.DOTALL | re.IGNORECASE)
    match = pattern.search(content)

    if match:
        return match.group(1)
    else:
        print(f"Error: Could not find section with id='{SECTION_ID}' in {SOURCE_FILE}")
        return None

def update_files(master_widget):
    """Updates all HTML files with the master widget."""
    count = 0
    # Files to exclude if any (e.g., the source file itself)
    exclude_files = [SOURCE_FILE, 'reference_site.html']

    for filename in os.listdir(TARGET_DIR):
        if filename.endswith('.html') and filename not in exclude_files:
            file_path = os.path.join(TARGET_DIR, filename)
            
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            # Regex to find existing widget to replace
            pattern = re.compile(r'(<section[^>]*id=["\']feedback-system["\'][^>]*>.*?</section>)', re.DOTALL | re.IGNORECASE)
            
            if pattern.search(content):
                # Replace existing
                new_content = pattern.sub(master_widget, content)
                if new_content != content:
                    with open(file_path, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    print(f"Updated: {filename}")
                    count += 1
                else:
                    print(f"Skipped (No changes): {filename}")
            else:
                 # Check if we should insert it (e.g., before footer or trusted-by) if it doesn't exist?
                 # For now, consistent with user request "update one, some stay outdated", implies it exists but is old.
                 # We can warn if missing.
                 print(f"Skipped (Widget not found): {filename}")

    print(f"Total files updated: {count}")

if __name__ == "__main__":
    print(f"Using {SOURCE_FILE} as master template...")
    widget_html = get_master_widget()
    if widget_html:
        #print("Master widget extracted successfully.")
        update_files(widget_html)
