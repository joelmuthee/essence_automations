
$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations" -Filter "*.html"
$target = ">Schedule a Meeting</a>"
$replacement = ">Schedule a Discovery Call</a>"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match $target) {
        $newContent = $content -replace $target, $replacement
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8
        Write-Host "Updated $($file.Name)"
    }
}
