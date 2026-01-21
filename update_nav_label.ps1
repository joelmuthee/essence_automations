$root = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $root -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    # Replace Menu Label "Book a Call" with "Schedule a Meeting"
    # This targets <li><a href="demos.html">Book a Call</a></li> typically
    if ($content -match '>Book a Call</a>') {
        $content = $content -replace '>Book a Call</a>', '>Schedule a Meeting</a>'
        $modified = $true
    }
    
    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
