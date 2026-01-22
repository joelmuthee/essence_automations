
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path "$directory\*.html"
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($file in $files) {
    try {
        $content = [System.IO.File]::ReadAllText($file.FullName)
        $originalContent = $content

        # 1. Remove inline style from h3 inside stat-card
        # Regex to handle potential variation in whitespace
        # Look for: <h3 ... style="font-size: 2.5rem; margin-bottom: 0;">
        $pattern1 = '(<h3[^>]*?class="[^"]*?gradient-text[^"]*?")\s+style="[^"]*?font-size:\s*2\.5rem[^"]*?"'
        $content = [regex]::Replace($content, $pattern1, '$1')

        # 2. Remove inline style from grid-container
        # Look for: <div ... style="gap: 1.5rem;">
        $pattern2 = '(<div[^>]*?class="[^"]*?grid-container[^"]*?")\s+style="[^"]*?gap:\s*1\.5rem;[^"]*?"'
        $content = [regex]::Replace($content, $pattern2, '$1')

        # 3. Clean up stats-section inline style
        # Look for: <section class="stats-section" style="padding: 2rem 5%; text-align: center;">
        $pattern3 = '(<section[^>]*?class="[^"]*?stats-section[^"]*?")\s+style="[^"]*?padding:\s*2rem\s+5%;[^"]*?"'
        $content = [regex]::Replace($content, $pattern3, '$1')

        if ($content -ne $originalContent) {
            [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            Write-Host "Updated $($file.Name)"
        }
        else {
            Write-Host "No changes in $($file.Name)"
        }
    }
    catch {
        Write-Host "Error processing $($file.Name): $_"
    }
}
