import os
import glob

def fix_encoding(directory):
    files = glob.glob(os.path.join(directory, '*.html'))
    print(f"Found {len(files)} HTML files.")

    for file_path in files:
        try:
            # Try reading as UTF-8 first
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            # If successful, just write it back to ensure BOM is handled or normalization is consistent if needed, 
            # but mainly to ensure it IS UTF-8 on disk.
            # Actually, if it reads as UTF-8, it might already be fine, but let's rewrite to be sure.
            with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
                f.write(content)
            print(f"Verified/Saved as UTF-8: {os.path.basename(file_path)}")
        except UnicodeDecodeError:
            print(f"Encoding mismatch detected in: {os.path.basename(file_path)}. Attempting to recover...")
            # Try reading with other encodings (e.g. cp1252 which is common on Windows)
            try:
                with open(file_path, 'r', encoding='cp1252') as f:
                    content = f.read()
                # Write back as UTF-8
                with open(file_path, 'w', encoding='utf-8', newline='\n') as f:
                    f.write(content)
                print(f"Fixed encoding for: {os.path.basename(file_path)}")
            except Exception as e:
                print(f"Failed to recover {os.path.basename(file_path)}: {e}")

if __name__ == "__main__":
    target_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
    fix_encoding(target_dir)
