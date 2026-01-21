$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations" -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace "CRM with Desktop & Mobile App" in the submenu with "CRM With App"
    if ($content -match ">CRM with Desktop & Mobile App<") {
        Write-Host "Updating submenu in $($file.Name)..."
        $content = $content -replace ">CRM with Desktop & Mobile App<", ">CRM With App<"
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}
Write-Host "Submenu link update complete."
