$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content

    # Replace in Link Text (Nav and Footer)
    $content = $content -replace '>Online Calendar</a>', '>Appointment Calendar</a>'
    
    # Replace in Title Tag
    $content = $content -replace '<title>Online Calendar \|', '<title>Appointment Calendar |'
    
    # Replace in Meta Tags (OG Title)
    $content = $content -replace 'content="Online Calendar \|', 'content="Appointment Calendar |'

    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
