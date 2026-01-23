
$files = @(
    "about.html",
    "ads-manager.html",
    "ai-chat.html",
    "crm.html",
    "documents.html",
    "email-marketing.html",
    "gmb-manager.html",
    "index.html",
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

$baseDir = "c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

foreach ($filename in $files) {
    $path = Join-Path $baseDir $filename
    if (-not (Test-Path $path)) {
        Write-Host "Skipping $filename : Not found"
        continue
    }

    $content = Get-Content $path -Raw -Encoding utf8

    # Remove existing section using regex
    $content = $content -replace '(?s)\s*<section class="trusted-by">.*?</section>', ''

    # Insert new section before </main>
    if ($content -match '</main>') {
        $newContent = $content.Replace('</main>', "$sectionHtml`n    </main>")
        Set-Content -Path $path -Value $newContent -Encoding utf8
        Write-Host "Updated $filename"
    } else {
        Write-Host "Skipping $filename : </main> tag not found"
    }
}

