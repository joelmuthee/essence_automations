Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/uploaded_image_1768815990417.jpg"
$destFavicon = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\favicon.png"
$destHeader = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-header.png"
$destFooter = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-footer.png"

try {
    $img = [System.Drawing.Image]::FromFile($source)
    
    # 1. Create Favicon (Crop to EA initials)
    # The image is square. The "EA" is in the center-top. Text "ESSENCE AUTOMATIONS" is at bottom.
    # We want to crop out the text for the favicon to ensure max legibility of "EA".
    # Let's say we keep top 80%? or trim margins?
    # HEURISTIC: Center crop 80% width, top 75% height?
    # Let's try to grab the center square area.
    
    $cropSize = [int]($img.Width * 0.8)
    $x = [int](($img.Width - $cropSize) / 2)
    # Shift Y up slightly to just capture EA, avoid bottom text
    $y = [int]($img.Height * 0.1) 
    
    $rect = New-Object System.Drawing.Rectangle($x, $y, $cropSize, $cropSize)
    $resFav = New-Object System.Drawing.Bitmap(256, 256)
    $graphFav = [System.Drawing.Graphics]::FromImage($resFav)
    $graphFav.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphFav.DrawImage($img, [System.Drawing.Rectangle]::new(0, 0, 256, 256), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $resFav.Save($destFavicon, [System.Drawing.Imaging.ImageFormat]::Png)
    $resFav.Dispose()
    $graphFav.Dispose()
    Write-Host "Updated favicon.png from uploaded image."

    # 2. Create Header Logo (Full Logo, Resized)
    # Header is small (e.g. 60px height). We'll resize the FULL square image.
    $resHeader = New-Object System.Drawing.Bitmap(100, 100) # Slightly larger for retina/crispness
    $graphHeader = [System.Drawing.Graphics]::FromImage($resHeader)
    $graphHeader.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphHeader.DrawImage($img, 0, 0, 100, 100)
    $resHeader.Save($destHeader, [System.Drawing.Imaging.ImageFormat]::Png)
    $resHeader.Dispose()
    $graphHeader.Dispose()
    Write-Host "Updated logo-header.png"

    # 3. Create Footer Logo (Full Logo, Resized)
    # Footer is larger (e.g. 200px width).
    $resFooter = New-Object System.Drawing.Bitmap(250, 250)
    $graphFooter = [System.Drawing.Graphics]::FromImage($resFooter)
    $graphFooter.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphFooter.DrawImage($img, 0, 0, 250, 250)
    $resFooter.Save($destFooter, [System.Drawing.Imaging.ImageFormat]::Png)
    $resFooter.Dispose()
    $graphFooter.Dispose()
    Write-Host "Updated logo-footer.png"

    $img.Dispose()
}
catch {
    Write-Error "Error: $_"
    exit 1
}
