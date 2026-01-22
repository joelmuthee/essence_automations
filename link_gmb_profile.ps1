Get-ChildItem -Path . -Filter *.html -Recurse | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    
    # Define regex to match the span, handling newlines and extra spaces
    # Regex explanation:
    # <span class="gradient-text"[^>]*> : Match span tag with class "gradient-text" and any other attributes
    # \s* : Match any whitespace (newlines, spaces)
    # Google Business : Match "Google Business"
    # \s+ : Match one or more whitespace characters (handling the split across lines)
    # Profile : Match "Profile"
    # \s* : Match any whitespace
    # </span> : Match closing tag
    
    $regex = '(?s)<span class="gradient-text"[^>]*>\s*Google Business\s+Profile\s*</span>'
    
    # Replacement string
    $replacement = '<a href="https://g.page/r/CR_sEbCTUfyYEBE/review" target="_blank" class="gradient-text" style="font-weight: 800; text-decoration: underline; cursor: pointer;">Google Business Profile</a>'
    
    if ($content -match $regex) {
        Write-Host "Updating identified GMB text in: $($_.Name)"
        $newContent = $content -replace $regex, $replacement
        Set-Content -Path $_.FullName -Value $newContent -Encoding UTF8
    }
}
