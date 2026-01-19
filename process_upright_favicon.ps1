Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/ea_logo_upright_1768815602183.png"
$destHighRes = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Logo_Upright_HighRes.png"
$destFavicon = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\favicon.png"

try {
    # Save High Res
    Copy-Item -Path $source -Destination $destHighRes -Force
    Write-Host "Saved High Res to: $destHighRes"

    # Resize for Favicon (keep it high quality, e.g., 256x256 or just copy if square)
    # The generated image is likely square. We'll just resize to 256x256 to be standard.
    
    $img = [System.Drawing.Image]::FromFile($source)
    $res = New-Object System.Drawing.Bitmap(256, 256)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graph.DrawImage($img, 0, 0, 256, 256)
    $res.Save($destFavicon, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()
    Write-Host "Overwrote favicon.png with new upright logo."
}
catch {
    Write-Error "Error: $_"
    exit 1
}
