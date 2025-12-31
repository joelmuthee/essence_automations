$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($content -match "pulse-glow") {
        $content = $content -replace "pulse-glow", ""
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Cleaned pulse-glow from $($file.Name)"
    }
}
