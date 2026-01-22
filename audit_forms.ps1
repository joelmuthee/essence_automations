
$directory = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$files = Get-ChildItem -Path "$directory\*.html"

Write-Host ("{0,-30} | {1,-20} | {2,-15} | {3}" -f "File", "Inline Min-Height", "Data-Height", "Status")
Write-Host ("-" * 90)

foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    
    # Regex to find conditional-content divs
    # This is a bit complex in PS due to multiline matching, so we'll do simple string parsing per file
    
    $matches = [regex]::Matches($content, '<div[^>]*?class="[^"]*?conditional-content[^"]*?"([^>]*)>')
    
    foreach ($match in $matches) {
        $attrs = $match.Groups[1].Value
        
        # Check inline style
        $inlineHeight = "None"
        if ($attrs -match 'min-height:\s*(\d+)px') {
            $inlineHeight = $matches[0].Groups[1].Value # Wait, this logic is slightly flawed in PS regex objects
            $inlineHeight = $Matches[1]
        }
        
        # Look ahead for data-height
        $startPos = $match.Index + $match.Length
        $searchLength = [math]::Min(1000, $content.Length - $startPos)
        $chunk = $content.Substring($startPos, $searchLength)
        
        $dataHeight = "Unknown"
        if ($chunk -match 'data-height="(\d+)"') {
            $dataHeight = $Matches[1]
        }
        
        $status = "OK (CSS Controlled)"
        if ($inlineHeight -ne "None") {
            $status = "Inline Style Active"
            if ($dataHeight -ne "Unknown" -and $inlineHeight -ne $dataHeight) {
                # Simple mismatch check (string comparison isn't perfect but good enough for 471 vs 475)
                $diff = [math]::Abs([int]$inlineHeight - [int]$dataHeight)
                if ($diff -gt 50) {
                    $status = "MISMATCH ($inlineHeight vs $dataHeight)"
                }
            }
        }
        
        Write-Host ("{0,-30} | {1,-20} | {2,-15} | {3}" -f $file.Name, $inlineHeight, $dataHeight, $status)
    }
}
