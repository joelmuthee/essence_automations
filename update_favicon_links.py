import os

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
target_str = '<link rel="icon" type="image/svg+xml" href="favicon.svg">'
replacement_str = '<link rel="icon" type="image/png" href="favicon.png">'

count = 0
for filename in os.listdir(directory):
    if filename.endswith(".html"):
        filepath = os.path.join(directory, filename)
        try:
            with open(filepath, "r", encoding="utf-8") as f:
                content = f.read()
            
            if target_str in content:
                new_content = content.replace(target_str, replacement_str)
                with open(filepath, "w", encoding="utf-8") as f:
                    f.write(new_content)
                print(f"Updated: {filename}")
                count += 1
            else:
                 # Try case insensitive or partial matches if exact match failed?
                 # Let's simple check if it has favicon.svg but different attributes order?
                 if "favicon.svg" in content:
                     print(f"Skipped (exact match not found, but file contains 'favicon.svg'): {filename}")

        except Exception as e:
            print(f"Error processing {filename}: {e}")

print(f"Total files updated: {count}")
