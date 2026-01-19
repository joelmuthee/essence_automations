Add-Type -AssemblyName System.Drawing
$source = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\EA_Logo_Upright_HighRes.png"
$destHeader = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-header.png"
$destFooter = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\logo-footer.png"

function Resize-Image {
    param(
        [string]$SourcePath,
        [string]$DestPath,
        [int]$Width,
        [int]$Height
    )
    
    try {
        $img = [System.Drawing.Image]::FromFile($SourcePath)
        $res = New-Object System.Drawing.Bitmap($Width, $Height)
        $graph = [System.Drawing.Graphics]::FromImage($res)
        $graph.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graph.DrawImage($img, 0, 0, $Width, $Height)
        $res.Save($DestPath, [System.Drawing.Imaging.ImageFormat]::Png)
        
        $img.Dispose()
        $res.Dispose()
        $graph.Dispose()
        Write-Host "Created $DestPath ($Width x $Height)"
    }
    catch {
        Write-Error "Error resizing image to $DestPath : $_"
    }
}

# Create Header Logo (60x60)
Resize-Image -SourcePath $source -DestPath $destHeader -Width 60 -Height 60

# Create Footer Logo (150x150)
Resize-Image -SourcePath $source -DestPath $destFooter -Width 150 -Height 150
