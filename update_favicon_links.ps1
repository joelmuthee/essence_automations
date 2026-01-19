$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$targetStr = '<link rel="icon" type="image/svg+xml" href="favicon.svg">'
$replacementStr = '<link rel="icon" type="image/png" href="favicon.png">'

$files = Get-ChildItem -Path $directory -Filter "*.html"

$count = 0
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content -like "*$targetStr*") {
        $newContent = $content.Replace($targetStr, $replacementStr)
        $newContent | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Updated: $($file.Name)"
        $count++
    }
    elseif ($content -like "*favicon.svg*") {
        Write-Host "Skipped (exact match not found): $($file.Name)"
    }
}

Write-Host "Total files updated: $count"
