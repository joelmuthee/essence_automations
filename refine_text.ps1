$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

# 1. Highlight "Google Business Profile"
$oldGMB = "Google Business Profile"
$newGMB = '<span class="gradient-text" style="font-weight: 800;">Google Business Profile</span>'

# 2. Replace Rating Explanation
$oldExplanation = '(1 Star = Very Poor, 5 Stars = Excellent)'
$newExplanation = '(1 Star = &#128542;, 5 Stars = &#129321;)'
# &#128542; = Disappointed Confounded Face 😖 (using slightly different ones for better compatibility if needed, but hex codes are safer in HTML)
# Let's use Hex entities or just symbols if UTF8 is consistent.
# 1 Star = 😞 (&#128542;)
# 5 Stars = 🤩 (&#129321;)

Get-ChildItem -Path $targetDir -Filter "*.html" | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    $modified = $false

    # Apply GMB Highlight (only if not already highlighted)
    if ($content -match "Google Business Profile" -and -not ($content -match "gradient-text.*Google Business Profile")) {
        $content = $content -replace "Google Business Profile", $newGMB
        $modified = $true
        Write-Host "Highlighted GMB in $($_.Name)"
    }

    # Apply Emoji Explanation
    if ($content -match [regex]::Escape($oldExplanation)) {
        $content = $content -replace [regex]::Escape($oldExplanation), $newExplanation
        $modified = $true
        Write-Host "Updated emojis in $($_.Name)"
    }

    if ($modified) {
        Set-Content -Path $path -Value $content -Encoding utf8
    }
}
