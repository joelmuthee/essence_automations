$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $directory -Filter "*.html"

# Previous state was 80px. New target is 120px.
$find = 'style="height: 80px;"'
$replace = 'style="height: 120px;"'

$count = 0
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content.Contains($find)) {
        $content = $content.Replace($find, $replace)
        $content | Set-Content -Path $file.FullName -Encoding UTF8
        Write-Host "Resized logo to 120px in: $($file.Name)"
        $count++
    }
    else {
        # Fallback check: maybe it's still 50px if something failed, or maybe the string format is slightly different?
        # Let's try 50px too just in case.
        $find50 = 'style="height: 50px;"'
        if ($content.Contains($find50)) {
            $content = $content.Replace($find50, $replace)
            $content | Set-Content -Path $file.FullName -Encoding UTF8
            Write-Host "Resized logo (from 50px) to 120px in: $($file.Name)"
            $count++
        }
    }
}

Write-Host "Total files updated to 120px: $count"
