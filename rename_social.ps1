$files = Get-ChildItem -Path . -Filter *.html

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $originalContent = $content

    # Replace in Link Text (Nav and Footer)
    $content = $content -replace '>Social Planner</a>', '>Social Media Management</a>'
    
    # Replace in Title Tag
    $content = $content -replace '<title>Social Planner \|', '<title>Social Media Management |'

    # Replace in H1 or H3 headers
    $content = $content -replace '<h3>Social Planner</h3>', '<h3>Social Media Management</h3>'
    $content = $content -replace '<h1 class="fade-in-up">Social Planner</h1>', '<h1 class="fade-in-up">Social Media Management</h1>'
    $content = $content -replace '<span class="gradient-text">Social Planner</span>', '<span class="gradient-text">Social Media Management</span>'
    
    # Replace in Meta Tags (OG Title)
    $content = $content -replace 'content="Social Planner \|', 'content="Social Media Management |'

    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
