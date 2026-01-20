from PIL import Image, ImageOps

def create_social_image():
    # Configuration
    logo_path = "EA_Google_Logo_HighRes.png"
    output_path = "social-share.png"
    bg_color = (5, 5, 16)  # #050510 from style.css
    canvas_size = (1200, 630)
    logo_max_width = 800  # Reasonable size for the logo within the canvas
    logo_max_height = 500

    try:
        # Load Logo
        logo = Image.open(logo_path).convert("RGBA")
        print(f"Loaded logo: {logo.size}")

        # Resize logo to fit within max bounds while maintaining aspect ratio
        logo.thumbnail((logo_max_width, logo_max_height), Image.Resampling.Lancos)
        print(f"Resized logo to: {logo.size}")

        # Create Background
        img = Image.new("RGB", canvas_size, bg_color)

        # Calculate centered position
        x = (canvas_size[0] - logo.size[0]) // 2
        y = (canvas_size[1] - logo.size[1]) // 2

        # Paste logo onto background (using its alpha channel as mask)
        img.paste(logo, (x, y), logo)

        # Save
        img.save(output_path, "PNG")
        print(f"Successfully created {output_path}")

    except Exception as e:
        print(f"Error creating image: {e}")

if __name__ == "__main__":
    create_social_image()
