
import os

section_html = """
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
"""

files = [
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
]

base_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"

for filename in files:
    path = os.path.join(base_dir, filename)
    if not os.path.exists(path):
        print(f"Skipping {filename}: Not found")
        continue

    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove existing section if present (to avoid duplicates or handle the move)
    if '<section class="trusted-by">' in content:
        # Simple removal: this assumes unique identifying block or standard formatting
        # We'll use a partition approach which is safer for big blocks if exact match fails
        # But since I just wrote it, exact match might work. Let's try standard split/join
        pass 
        # Actually, let's just strip it out carefully.
        import re
        content = re.sub(r'\s*<section class="trusted-by">.*?</section>', '', content, flags=re.DOTALL)
        print(f"Removed existing section from {filename}")

    # Insert before </main>
    if '</main>' in content:
        new_content = content.replace('</main>', f'{section_html}\n    </main>')
        with open(path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filename}")
    else:
        print(f"Skipping {filename}: </main> tag not found")

