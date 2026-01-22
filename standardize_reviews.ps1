
$sourceFile = "reputation-management.html"
$targetDir = "."
$sectionId = "feedback-system"

# 1. Read Master File
if (-not (Test-Path $sourceFile)) {
    Write-Error "Source file $sourceFile not found."
    exit 1
}

$content = Get-Content -Path $sourceFile -Raw -Encoding UTF8

# 2. Extract Master Widget Inner Content
# Target the section with class 'feedback-system'
$pattern = '(?s)<section[^>]*class=["''][^"''\n]*feedback-system[^"''\n]*["''][^>]*>(.*?)</section>'

if ($content -match $pattern) {
    $masterInnerContent = $matches[1]
    Write-Host "Master widget content extracted."
}
else {
    Write-Error "Could not find feedback-system section in source."
    exit 1
}

# 3. Iterate and Update Files
$files = Get-ChildItem -Path $targetDir -Filter "*.html"
$count = 0

foreach ($file in $files) {
    if ($file.Name -eq $sourceFile -or $file.Name -eq "reference_site.html") {
        continue
    }

    $filePath = $file.FullName
    $fileContent = Get-Content -Path $filePath -Raw -Encoding UTF8

    # Match the target section completely
    # pattern: <section ... class="feedback-system" ...> ... </section>
    $targetPattern = '(?s)<section[^>]*class=["''][^"''\n]*feedback-system[^"''\n]*["''][^>]*>.*?</section>'
    
    if ($fileContent -match $targetPattern) {
        # Define the clean container tag for all other pages
        $cleanOpeningTag = '<section id="feedback-system" class="feedback-system glass-effect">'
        $closingTag = '</section>'
        
        # Construct the full new section
        $newSection = "${cleanOpeningTag}${masterInnerContent}${closingTag}"
        
        # Replace the entire old section with the new clean section
        $regex = [regex]$targetPattern
        $newFileContent = $regex.Replace($fileContent, $newSection, 1)
        
        # Check if actually changed (comparing string length or hash might be faster but string compare is fine for this size)
        if ($newFileContent -ne $fileContent) {
            $newFileContent | Set-Content -Path $filePath -Encoding UTF8 -NoNewline
            Write-Host "Updated (Reset Attributes): $($file.Name)"
            $count++
        }
        else {
            Write-Host "Skipped (No changes): $($file.Name)"
        }
    }
    else {
        Write-Host "Skipped (Widget not found): $($file.Name)"
    }
}

Write-Host "Total files updated: $count"
