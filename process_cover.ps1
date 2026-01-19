Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/gbp_cover_orange_1768813604182.png"
$destHighRes = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_GBP_Cover_HighRes.png"
$dest16x9 = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_GBP_Cover_16x9.png"

try {
    # Load Image
    $img = [System.Drawing.Image]::FromFile($source)
    
    # Save High Res Copy
    $img.Save($destHighRes, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Saved High Res to: $destHighRes"

    # Calculate 16:9 Crop
    $targetRatio = 16 / 9
    $currentRatio = $img.Width / $img.Height
    
    $cropWidth = $img.Width
    $cropHeight = $img.Height
    $x = 0
    $y = 0

    if ($currentRatio -gt $targetRatio) {
        # Image is wider than 16:9, crop width
        $cropWidth = [int]($img.Height * $targetRatio)
        $x = [int](($img.Width - $cropWidth) / 2)
    }
    elseif ($currentRatio -lt $targetRatio) {
        # Image is taller than 16:9, crop height
        $cropHeight = [int]($img.Width / $targetRatio)
        $y = [int](($img.Height - $cropHeight) / 2)
    }

    $rect = New-Object System.Drawing.Rectangle($x, $y, $cropWidth, $cropHeight)
    $res = New-Object System.Drawing.Bitmap($cropWidth, $cropHeight)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    # Draw cropped area
    $graph.DrawImage($img, [System.Drawing.Rectangle]::new(0, 0, $cropWidth, $cropHeight), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $res.Save($dest16x9, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Saved 16:9 version to: $dest16x9"

    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()

}
catch {
    Write-Error "Error: $_"
    exit 1
}
