Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/uploaded_image_1768815990417.jpg"
$destHeader = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-header.png"
$destFooter = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-footer.png"

try {
    $img = [System.Drawing.Image]::FromFile($source)

    # 1. Create Header Logo (Higher Res for crispness)
    # 400x400 source allows up to 200px display comfortably (Retina)
    $resHeader = New-Object System.Drawing.Bitmap(400, 400)
    $graphHeader = [System.Drawing.Graphics]::FromImage($resHeader)
    $graphHeader.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphHeader.DrawImage($img, 0, 0, 400, 400)
    $resHeader.Save($destHeader, [System.Drawing.Imaging.ImageFormat]::Png)
    $resHeader.Dispose()
    $graphHeader.Dispose()
    Write-Host "Updated logo-header.png (400x400)"

    # 2. Create Footer Logo (Larger)
    # 500x500 source
    $resFooter = New-Object System.Drawing.Bitmap(500, 500)
    $graphFooter = [System.Drawing.Graphics]::FromImage($resFooter)
    $graphFooter.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphFooter.DrawImage($img, 0, 0, 500, 500)
    $resFooter.Save($destFooter, [System.Drawing.Imaging.ImageFormat]::Png)
    $resFooter.Dispose()
    $graphFooter.Dispose()
    Write-Host "Updated logo-footer.png (500x500)"

    $img.Dispose()
}
catch {
    Write-Error "Error: $_"
    exit 1
}
