$files = Get-ChildItem -Path "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations\*.html"

foreach ($file in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    $enc = [System.Text.Encoding]::UTF8
    $content = $enc.GetString($bytes)
    
    $sb = New-Object System.Text.StringBuilder
    
    for ($i = 0; $i -lt $content.Length; $i++) {
        $c = $content[$i]
        
        if ([Char]::IsHighSurrogate($content, $i) -and ($i + 1 -lt $content.Length) -and [Char]::IsLowSurrogate($content, $i + 1)) {
            $high = $content[$i]
            $low = $content[$i + 1]
            $codepoint = [System.Char]::ConvertToUtf32($high, $low)
            $sb.Append("&#$codepoint;") | Out-Null
            $i++ 
        }
        elseif ([int]$c -gt 127) {
            $code = [int]$c
            $sb.Append("&#$code;") | Out-Null
        }
        else {
            $sb.Append($c) | Out-Null
        }
    }
    
    $newContent = $sb.ToString()
    [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.Encoding]::UTF8)
    Write-Host "Processed: $($file.Name)"
}
