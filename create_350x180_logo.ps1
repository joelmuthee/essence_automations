Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/uploaded_image_1768815990417.jpg"
$dest = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Logo_350x180.png"

try {
    $img = [System.Drawing.Image]::FromFile($source)
    
    # Target Dims
    $tWidth = 350
    $tHeight = 180
    
    # Calculate scale to fit
    $ratioX = $tWidth / $img.Width
    $ratioY = $tHeight / $img.Height
    $ratio = [Math]::Min($ratioX, $ratioY)
    
    $newWidth = [int]($img.Width * $ratio)
    $newHeight = [int]($img.Height * $ratio)
    
    $posX = [int](($tWidth - $newWidth) / 2)
    $posY = [int](($tHeight - $newHeight) / 2)
    
    # Create canvas
    $res = New-Object System.Drawing.Bitmap($tWidth, $tHeight)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # Get background color from top-left pixel
    $bgColor = $img.GetPixel(0, 0)
    $brush = New-Object System.Drawing.SolidBrush($bgColor)
    $graph.FillRectangle($brush, 0, 0, $tWidth, $tHeight)
    
    # Draw scaled image centered
    $graph.DrawImage($img, $posX, $posY, $newWidth, $newHeight)
    
    $res.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()
    $brush.Dispose()
    
    Write-Host "Created 350x180 logo at: $dest"
}
catch {
    Write-Error "Error: $_"
    exit 1
}
