$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $directory -Filter "*.html"

# Current Footer: <img src="logo-footer.png" alt="Essence Automations" class="footer-logo">
# Desired Footer: <a href="index.html"><img src="logo-footer.png" alt="Essence Automations" class="footer-logo"></a>

$find = '<img src="logo-footer.png" alt="Essence Automations" class="footer-logo">'
$replace = '<a href="index.html"><img src="logo-footer.png" alt="Essence Automations" class="footer-logo"></a>'

$count = 0
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content.Contains($find)) {
        # Check if already linked to avoid double linking
        $checkLinked = '<a href="index.html">' + $find
        if (-not $content.Contains($checkLinked)) {
            $content = $content.Replace($find, $replace)
            $content | Set-Content -Path $file.FullName -Encoding UTF8
            Write-Host "Linked footer logo in: $($file.Name)"
            $count++
        }
        else {
            Write-Host "Already linked in: $($file.Name)"
        }
    }
}
Write-Host "Total files updated: $count"
