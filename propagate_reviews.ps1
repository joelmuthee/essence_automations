$targetDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
$targetMarker = '<section class="trusted-by">'
$reviewSection = @"
        <section id="feedback-system" class="feedback-system glass-effect">
            <div class="feedback-container">
                <h2 class="fade-in-up">How Would You Rate Our Services?</h2>
                <p class="subtitle fade-in-up">Select a star rating below to share your feedback.</p>
                
                <div class="star-rating fade-in-up">
                    <input type="radio" id="star5" name="rating" value="5" /><label for="star5" title="5 stars">★</label>
                    <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="4 stars">★</label>
                    <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="3 stars">★</label>
                    <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="2 stars">★</label>
                    <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="1 star">★</label>
                </div>

                <!-- 1-4 Star Feedback Form -->
                <div id="feedback-form" class="conditional-content hidden">
                    <h3>We're sorry to hear that.</h3>
                    <p>Please let us know how we can improve.</p>
                    <form id="internal-feedback" onsubmit="handleFeedbackSubmit(event)">
                        <div class="form-group">
                            <input type="email" id="feedback-email" placeholder="Your Email Address" required>
                        </div>
                        <div class="form-group">
                            <textarea id="feedback-message" rows="4" placeholder="Your feedback..." required></textarea>
                        </div>
                        <button type="submit" class="btn-primary">Send Feedback</button>
                    </form>
                </div>

                <!-- 5 Star Success Message -->
                <div id="review-cta" class="conditional-content hidden">
                    <h3>Thank you for your support!</h3>
                    <p>We're thrilled you had a great experience. Could you please spare a moment to leave us a google review?</p>
                    <a href="https://g.page/r/CR_sEbCTUfyYEBE/review" target="_blank" class="btn-primary">Rate Us on Google</a>
                </div>
            </div>
        </section>

"@

Get-ChildItem -Path $targetDir -Filter "*.html" | Where-Object { $_.Name -ne "index.html" -and $_.Name -notlike "*reference*" } | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content $path -Raw -Encoding utf8
    
    if ($content -notmatch 'id="feedback-system"') {
        if ($content -match [regex]::Escape($targetMarker)) {
            $newContent = $content -replace [regex]::Escape($targetMarker), "$reviewSection`n$targetMarker"
            Set-Content -Path $path -Value $newContent -Encoding utf8
            Write-Host "Updated $($_.Name)"
        }
        else {
            Write-Host "Skipping $($_.Name): Marker not found."
        }
    }
    else {
        Write-Host "Skipping $($_.Name): Already updated."
    }
}
