
import os

directory = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
target_string = '>Schedule a Meeting</a>'
replacement_string = '>Schedule a Discovery Call</a>'

count = 0
for filename in os.listdir(directory):
    if filename.endswith(".html"):
        filepath = os.path.join(directory, filename)
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if target_string in content:
                new_content = content.replace(target_string, replacement_string)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")
                count += 1
        except Exception as e:
            print(f"Error processing {filename}: {e}")

print(f"Total files updated: {count}")
