$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"
$results = @()

foreach ($file in $files) {
    if ($file.Name -eq "index.html" -or $file.Name -eq "style.css") { continue }
    
    $content = Get-Content $file.FullName -Raw
    
    # 1. Grid Check
    $gridCount = 0
    if ($content -match 'class="[^"]*two-column-grid[^"]*"') {
        # Rudimentary count of direct children cards - not perfect but indicative
        # Assuming format: <div class="card glass-effect">
        $gridCount = ([regex]::Matches($content, 'class="card glass-effect"')).Count
    }
    
    # 2. Check for missing/corrupted icons (?? or unknown chars)
    $hasCorruptedIcons = $content -match "\?\?" -or $content -match "â" 
    
    # 3. Check for center alignment in odd grids
    $hasCenterFix = $content -match "grid-column: span 2" -or $content -match "margin: 0 auto"
    
    # 4. Check for mobile viewport tag
    $hasViewport = $content -match '<meta name="viewport"'
    
    $results += [PSCustomObject]@{
        File              = $file.Name
        GridCards         = $gridCount
        IsOdd             = ($gridCount % 2 -ne 0)
        HasCorruptedIcons = $hasCorruptedIcons
        HasCenterFix      = $hasCenterFix
        HasViewport       = $hasViewport
    }
}

$results | Format-Table -AutoSize
