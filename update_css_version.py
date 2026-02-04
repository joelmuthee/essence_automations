
import os
import re

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
current_version = "v=71"
new_version = "v=72"

count = 0
for filename in os.listdir(directory):
    if filename.endswith(".html"):
        filepath = os.path.join(directory, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if current_version in content:
                new_content = content.replace(current_version, new_version)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")
                count += 1
            else:
                # Try regex if exact string mismatch or just to be safe find any v=XX
                # But simple replace is safer for now if consistent.
                # Let's check if there are other versions
                pass
        except Exception as e:
            print(f"Error processing {filename}: {e}")

print(f"Updated {count} files.")
