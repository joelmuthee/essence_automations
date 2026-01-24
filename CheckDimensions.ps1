Add-Type -AssemblyName System.Drawing

$files = @(
    'client_1.png', 
    'client_2.jpg', 
    'client_3.jpg', 
    'client_4.jpg', 
    'client_5.png', 
    'client_6.jpg', 
    'client_7.png'
)

foreach ($f in $files) {
    if (Test-Path $f) {
        try {
            $img = [System.Drawing.Image]::FromFile($f)
            Write-Output "$f : $($img.Width)x$($img.Height)"
            $img.Dispose()
        }
        catch {
            Write-Output "Error reading $f"
        }
    }
}

$uploaded = 'C:\Users\Joel\.gemini\antigravity\brain\677a7c54-9821-4440-979c-5d99601db074\uploaded_media_1769271152684.jpg'
if (Test-Path $uploaded) {
    try {
        $img = [System.Drawing.Image]::FromFile($uploaded)
        Write-Output "Uploaded : $($img.Width)x$($img.Height)"
        $img.Dispose()
    }
    catch {
        Write-Output "Error reading Uploaded file"
    }
}
