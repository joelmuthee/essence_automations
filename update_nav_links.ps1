$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations" -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Replace "CRM & Mobile App" with "CRM With Desktop & Mobile App" ensuring it's likely a link text
    # Also handle "CRM & Mobile" which might be in footer or nav too.
    # The previous replace might have missed some since I used "CRM & Mobile App" in nav.
    # Let's target the exact link >CRM & Mobile App< and >CRM & Mobile< if exists.
    
    if ($content -match ">CRM & Mobile App<") {
        Write-Host "Updating $($file.Name)..."
        $content = $content -replace ">CRM & Mobile App<", ">CRM with Desktop & Mobile App<"
        $content = $content -replace ">CRM & Mobile<", ">CRM with Desktop & Mobile App<" # Safety net
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
    elseif ($content -match ">CRM & Mobile<") {
        Write-Host "Updating $($file.Name) (Short version)..."
        $content = $content -replace ">CRM & Mobile<", ">CRM with Desktop & Mobile App<"
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}
Write-Host "Navigation link update complete."
