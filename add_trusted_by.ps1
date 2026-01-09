$files = @(
    "about.html",
    "ads-manager.html",
    "ai-chat.html",
    "crm-mobile.html",
    "documents.html",
    "email-marketing.html",
    "gmb-manager.html",
    "online-calendar.html",
    "qr-codes.html",
    "reputation-management.html",
    "sms-marketing.html",
    "social-planner.html",
    "websites.html"
)

$sectionHtml = @"
        <section class="trusted-by">
            <h2 class="trusted-title fade-in-up">Trusted By Our Satisfied Clients</h2>
            <div class="slider">
                <div class="slide-track">
                    <!-- Original Set -->
                    <div class="slide"><img src="client_1.png" alt="Trusted Client 1"></div>
                    <div class="slide"><img src="client_2.jpg" alt="Trusted Client 2"></div>
                    <div class="slide"><img src="client_3.jpg" alt="Trusted Client 3"></div>
                    <div class="slide"><img src="client_4.jpg" alt="Trusted Client 4"></div>
                    <div class="slide"><img src="client_5.png" alt="Trusted Client 5" class="trusted-logo-large"></div>
                    <div class="slide"><img src="client_6.jpg" alt="Trusted Client 6" class="trusted-logo-large"></div>

                    <!-- Duplicate Set for Seamless Loop -->
                    <div class="slide"><img src="client_1.png" alt="Trusted Client 1"></div>
                    <div class="slide"><img src="client_2.jpg" alt="Trusted Client 2"></div>
                    <div class="slide"><img src="client_3.jpg" alt="Trusted Client 3"></div>
                    <div class="slide"><img src="client_4.jpg" alt="Trusted Client 4"></div>
                    <div class="slide"><img src="client_5.png" alt="Trusted Client 5" class="trusted-logo-large"></div>
                    <div class="slide"><img src="client_6.jpg" alt="Trusted Client 6" class="trusted-logo-large"></div>
                </div>
            </div>
        </section>
"@

foreach ($file in $files) {
    if (Test-Path $file) {
        $content = Get-Content $file -Raw -Encoding UTF8
        
        # Remove existing trusted-by section if found (regex to match the whole section)
        # Assuming typical HTML structure. Using non-greedy match.
        $content = $content -replace '(?s)<section class="trusted-by">.*?</section>', ''
        
        # Insert before </main>
        if ($content -match '</main>') {
            $content = $content.Replace('</main>', "$sectionHtml`n    </main>")
            Set-Content -Path $file -Value $content -Encoding UTF8
            Write-Host "Updated $file (Replaced/Inserted)"
        }
        else {
            Write-Host "Skipping $file : </main> not found"
        }
    }
    else {
        Write-Host "File not found: $file"
    }
}
