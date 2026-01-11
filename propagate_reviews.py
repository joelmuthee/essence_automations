import os

# The HTML content to insert
review_section = """        <section id="feedback-system" class="feedback-system glass-effect">
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

"""

target_dir = r"c:\Users\Joel\OneDrive\Documents\Anti Gravity\Essence Automations"
target_marker = '<section class="trusted-by">'

for filename in os.listdir(target_dir):
    if filename.endswith(".html") and filename != "index.html" and "reference" not in filename:
        filepath = os.path.join(target_dir, filename)
        
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Check if review section already exists
            if 'id="feedback-system"' in content:
                print(f"Skipping {filename}: Review section already present.")
                continue
            
            # Check if trusted-by section exists to insert before
            if target_marker in content:
                # Insert before trusted-by section
                new_content = content.replace(target_marker, review_section + target_marker)
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
                print(f"Updated {filename}")
            else:
                print(f"Skipping {filename}: 'Trusted By' section not found.")
                
        except Exception as e:
            print(f"Error processing {filename}: {e}")
