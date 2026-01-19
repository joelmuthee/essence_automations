Add-Type -AssemblyName System.Drawing
$source = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Google_Logo_HighRes.png"
$dest = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\favicon.png"

try {
    $img = [System.Drawing.Image]::FromFile($source)
    
    # Heuristic: Text is usually in the bottom 20%. 
    # The Logo "EA" is usually centered or slightly high.
    # We will crop to a central square that excludes the bottom area.
    
    # Define crop area
    $cropSize = [Math]::Min($img.Width, [int]($img.Height * 0.8))
    # Make it slightly smaller to zoom in on initials? Let's stick to max possible square above text.
    
    # Center X
    $x = [int](($img.Width - $cropSize) / 2)
    # Center Y, but biased upwards to avoid bottom text
    # If we take the top-most square?
    # $y = 0 
    # Let's try centering vertically within the top 85% space
    $availableHeight = [int]($img.Height * 0.85)
    $y = [int](($availableHeight - $cropSize) / 2)
    
    # Ensure non-negative
    if ($y -lt 0) { $y = 0 }
    
    $rect = New-Object System.Drawing.Rectangle($x, $y, $cropSize, $cropSize)
    
    $res = New-Object System.Drawing.Bitmap(512, 512)
    $graph = [System.Drawing.Graphics]::FromImage($res)
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    
    $graph.DrawImage($img, [System.Drawing.Rectangle]::new(0, 0, 512, 512), $rect, [System.Drawing.GraphicsUnit]::Pixel)
    
    $res.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Created favicon.png from cropped logo."
    
    $img.Dispose()
    $res.Dispose()
    $graph.Dispose()
}
catch {
    Write-Error "Error processing image: $_"
    exit 1
}
