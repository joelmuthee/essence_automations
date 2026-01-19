Add-Type -AssemblyName System.Drawing
$source = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/ea_logo_orange_1768813344392.png"
$destHighRes = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Google_Logo_HighRes.png"
$dest250 = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Google_Logo_250x250.png"

try {
    # Copy High Res
    Copy-Item -Path $source -Destination $destHighRes -Force
    Write-Host "Saved High Res to: $destHighRes"

    # Resize
    $img = [System.Drawing.Image]::FromFile($source)
    $res = New-Object System.Drawing.Bitmap(250, 250)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graph.DrawImage($img, 0, 0, 250, 250)
    $res.Save($dest250, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()
    Write-Host "Saved 250x250 to: $dest250"
}
catch {
    Write-Error "Error: $_"
    exit 1
}
