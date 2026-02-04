
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$current_version = "v=72"
$new_version = "v=73"
$count = 0

Get-ChildItem -Path $directory -Filter *.html | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match $current_version) {
        $new_content = $content -replace $current_version, $new_version
        Set-Content -Path $_.FullName -Value $new_content -Encoding UTF8
        Write-Host "Updated $($_.Name)"
        $count++
    }
}

Write-Host "Updated $count files."
