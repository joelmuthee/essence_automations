from PIL import Image
import shutil
import os

source = r"C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/ea_logo_square_1768813233838.png"
workspace = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
dest_high_res = os.path.join(workspace, "EA_Google_Logo_HighRes.png")
dest_250 = os.path.join(workspace, "EA_Google_Logo_250x250.png")

try:
    # Save High Res
    shutil.copy(source, dest_high_res)
    print(f"Saved High Res to: {dest_high_res}")

    # Resize to 250x250
    img = Image.open(source)
    img = img.resize((250, 250), Image.Resampling.LANCZOS)
    img.save(dest_250)
    print(f"Saved 250x250 to: {dest_250}")
except Exception as e:
    print(f"Error: {e}")
