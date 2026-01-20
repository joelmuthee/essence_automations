Add-Type -AssemblyName System.Drawing

$logoPath = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Google_Logo_HighRes.png"
$outputPath = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\social-share.png"
$bgColor = [System.Drawing.Color]::FromArgb(255, 5, 5, 16) # #050510
$canvasWidth = 1200
$canvasHeight = 630
$logoMaxWidth = 1200
$logoMaxHeight = 600

try {
    if (-not (Test-Path $logoPath)) {
        Write-Error "Logo not found at $logoPath"
        exit 1
    }

    $logo = [System.Drawing.Image]::FromFile($logoPath)
    
    # Calculate new dimensions for logo
    $ratioX = $logoMaxWidth / $logo.Width
    $ratioY = $logoMaxHeight / $logo.Height
    $ratio = [Math]::Min($ratioX, $ratioY)
    
    $newWidth = [int]($logo.Width * $ratio)
    $newHeight = [int]($logo.Height * $ratio)
    
    # Create Canvas
    $bmp = New-Object System.Drawing.Bitmap($canvasWidth, $canvasHeight)
    $graph = [System.Drawing.Graphics]::FromImage($bmp)
    $graph.Clear($bgColor)
    
    # High quality settings
    $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graph.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graph.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graph.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

    # Calculate centered position
    $x = ($canvasWidth - $newWidth) / 2
    $y = ($canvasHeight - $newHeight) / 2
    
    # Draw Logo
    $graph.DrawImage($logo, $x, $y, $newWidth, $newHeight)
    
    # Save
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    
    # Cleanup
    $graph.Dispose()
    $bmp.Dispose()
    $logo.Dispose()
    
    Write-Host "Successfully created $outputPath"
}
catch {
    Write-Error "Error creating image: $_"
    exit 1
}
