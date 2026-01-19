Add-Type -AssemblyName System.Drawing
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$sourceImg = "C:/Users/Joel/.gemini/antigravity/brain/d5ee9a72-9cec-4a0f-a0f1-c520fba8afcc/uploaded_image_1768815990417.jpg"
$destFavicon = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\favicon.png"

# --- 1. Update HTML Logo Size (50px -> 80px) ---
$files = Get-ChildItem -Path $directory -Filter "*.html"
$find = 'style="height: 50px;"'
$replace = 'style="height: 80px;"'
$count = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($content.Contains($find)) {
        $content = $content.Replace($find, $replace)
        $content | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Updated size in: $($file.Name)"
        $count++
    }
}
Write-Host "Total HTML files resized: $count"

# --- 2. Re-crop Favicon (Tight Zoom) ---
try {
    $img = [System.Drawing.Image]::FromFile($sourceImg)
    
    # 60% Crop heuristic to zoom in on "EA"
    # Assumes EA is centered.
    $cropRatio = 0.60
    
    $cropWidth = [int]($img.Width * $cropRatio)
    $cropHeight = [int]($img.Height * $cropRatio) # Square crop assumption if image is square
    
    # Center X
    $x = [int](($img.Width - $cropWidth) / 2)
    
    # Center Y - Shift UP slightly because "EA" is usually optical center, not geometric center due to text bottom
    # Geometric Center Y:
    # $y = [int](($img.Height - $cropHeight) / 2)
    # Let's shift it up by 10% of the original height to avoid bottom text
    $y = [int](($img.Height - $cropHeight) / 2) - [int]($img.Height * 0.05)
    
    if ($y -lt 0) { $y = 0 }

    $rect = New-Object System.Drawing.Rectangle($x, $y, $cropWidth, $cropHeight)
    $res = New-Object System.Drawing.Bitmap(256, 256)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    $graph.DrawImage($img, [System.Drawing.Rectangle]::new(0, 0, 256, 256), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $res.Save($destFavicon, [System.Drawing.Imaging.ImageFormat]::Png)
    
    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()
    Write-Host "Overwrote favicon.png with tighter crop."
}
catch {
    Write-Error "Favicon error: $_"
}
