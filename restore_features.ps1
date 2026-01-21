
# GMB Content
$gmbContent = @"
        <section class="services">
            <div class="center-text" style="text-align: center; margin-bottom: 5rem; margin-top: 2rem;">
                <h2 class="fade-in-up">Powerful Features</h2>
                <div class="grid-container three-column-grid">
                    <div class="card glass-effect">
                        <div class="icon">&#128640;</div>
                        <h3>Rank Higher</h3>
                        <p>Optimize your profile with AI-driven keywords and descriptions to dominate local search.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#11088;</div>
                        <h3>Review Management</h3>
                        <p>Automate review requests and replies to build trust and boost your star rating.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128202;</div>
                        <h3>Performance Insights</h3>
                        <p>Track calls, clicks, and views with detailed analytics to measure your ROI.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128172;</div>
                        <h3>Auto-Post</h3>
                        <p>Schedule posts, offers, and events to keep your audience engaged and informed.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#129302;</div>
                        <h3>AI Assistant</h3>
                        <p>Generate optimized descriptions and replies instantly with our built-in AI tools.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128222;</div>
                        <h3>Missed Call Text Back</h3>
                        <p>Turn missed calls into conversations automatically via SMS.</p>
                    </div>
                </div>
            </div>
            <div class="section-header">
"@

# Ads Content
$adsContent = @"
        <section class="services">
            <div class="center-text" style="text-align: center; margin-bottom: 5rem; margin-top: 2rem;">
                <h2 class="fade-in-up">Powerful Features</h2>
                <div class="grid-container three-column-grid">
                    <div class="card glass-effect">
                        <div class="icon">&#127919;</div>
                        <h3>Multi-Platform</h3>
                        <p>Launch ads on Google, Facebook, Instagram, and TikTok from a single dashboard.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#129302;</div>
                        <h3>AI Ad Creation</h3>
                        <p>Generate high-converting headlines, descriptions, and creatives in seconds.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128200;</div>
                        <h3>Smart Optimization</h3>
                        <p>Our AI monitors performance 24/7 and adjusts bids to maximize your ROI.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128100;</div>
                        <h3>Audience Targeting</h3>
                        <p>Pinpoint your ideal customers with advanced targeting options and lookalike audiences.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128202;</div>
                        <h3>Real-Time Analytics</h3>
                        <p>Visualize your campaign performance with easy-to-understand charts and reports.</p>
                    </div>
                    <div class="card glass-effect">
                        <div class="icon">&#128176;</div>
                        <h3>Budget Control</h3>
                        <p>Set daily or lifetime budgets to ensure you never overspend.</p>
                    </div>
                </div>
            </div>
            <div class="section-header">
"@

# Update GMB
$gmbFile = "gmb-manager.html"
$gmbHtml = Get-Content $gmbFile -Raw -Encoding UTF8
if ($gmbHtml -notmatch "Powerful Features") {
    $gmbHtml = $gmbHtml -replace '<section class="services">\s*<div class="section-header">', $gmbContent
    Set-Content $gmbFile $gmbHtml -Encoding UTF8
    Write-Host "Updated GMB Manager"
}

# Update Ads
$adsFile = "ads-manager.html"
$adsHtml = Get-Content $adsFile -Raw -Encoding UTF8
if ($adsHtml -notmatch "Powerful Features") {
    $adsHtml = $adsHtml -replace '<section class="services">\s*<div class="section-header">', $adsContent
    Set-Content $adsFile $adsHtml -Encoding UTF8
    Write-Host "Updated Ads Manager"
}

# Update Reputation (Review) - Rename header and grid class
$repFile = "reputation-management.html"
$repHtml = Get-Content $repFile -Raw -Encoding UTF8
if ($repHtml -match "Why You Need This") {
    $repHtml = $repHtml -replace "Why You Need This", "Powerful Features"
    $repHtml = $repHtml -replace "two-column-grid", "three-column-grid"
    Set-Content $repFile $repHtml -Encoding UTF8
    Write-Host "Updated Reputation Management"
}
