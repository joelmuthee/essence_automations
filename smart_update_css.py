import os
import re

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
new_version_num = 106 

# Find the highest version currently in use to be safe, or just force 106?
# Let's force a high number to sync everything. 
# Explicitly set to 110 to be sure we are ahead of everything (v=105 was seen).
target_version = 110
pattern = re.compile(r'style\.css\?v=\d+')
replacement = f'style.css?v={target_version}'

count = 0
for filename in os.listdir(directory):
    if filename.endswith(".html"):
        filepath = os.path.join(directory, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            new_content, n = pattern.subn(replacement, content)
            
            if n > 0:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename} to {target_version}")
                count += 1
        except Exception as e:
            print(f"Error processing {filename}: {e}")

print(f"Updated {count} files to version {target_version}.")
