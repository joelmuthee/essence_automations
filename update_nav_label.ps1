$root = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path $root -Filter "*.html"

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false
    
    # Replace Menu Label
    if ($content -match '>Demos</a>') {
        $content = $content -replace '>Demos</a>', '>Book a Call</a>'
        $modified = $true
    }
    
    # If this is demos.html, update the internal content too to be more "Consultation" focused
    if ($file.Name -eq "demos.html") {
        # Update Title
        $content = $content -replace '<title>Book a Demo', '<title>Book a Strategy Call'
        
        # Update Hero/Headers
        $content = $content -replace 'Book a Demo', 'Book a Strategy Call'
        $content = $content -replace 'Schedule a live demo to see how we can automate your business.', 'Schedule a live call to discuss how we can automate your business.'
        
        # Keep "See It In Action"? Maybe "Let''s Discuss Your Vision"?
        # User said "Demos ... does not make any sense".
        # Let's change "See It In Action" to "Let''s Discuss Your Vision"
        # Only if we find exactly that string.
        # $content = $content -replace 'See It In Action', 'Let''s Discuss Your Vision'
        # I'll stick to safer "Book a Strategy Call" changes first.
        
        $modified = $true
    }

    if ($modified) {
        $content | Set-Content -Path $file.FullName -Encoding UTF8 -NoNewline
        Write-Host "Updated $($file.Name)"
    }
}
