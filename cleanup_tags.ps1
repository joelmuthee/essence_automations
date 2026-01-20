$keepTag = "v1.0.7"
$tags = git tag

foreach ($tag in $tags) {
    if ($tag -ne $keepTag) {
        Write-Host "Deleting tag: $tag"
        
        # Delete local
        git tag -d $tag
        
        # Delete remote
        git push --delete origin $tag
    }
}

Write-Host "Cleanup complete. Kept tag: $keepTag"
