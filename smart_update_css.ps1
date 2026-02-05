$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$target_version = 111
$replacement = "style.css?v=$target_version"
$regex = "style\.css\?v=\d+"
$count = 0

Get-ChildItem -Path $directory -Filter *.html | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match $regex) {
        $new_content = $content -replace $regex, $replacement
        Set-Content -Path $_.FullName -Value $new_content -Encoding UTF8
        Write-Host "Updated $($_.Name) to v=$target_version"
        $count++
    }
}

Write-Host "Updated $count files."
