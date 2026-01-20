// Main JS file

// Cursor Effect
const cursor = document.querySelector('.cursor-glow');
document.addEventListener('mousemove', (e) => {
    cursor.style.left = e.clientX + 'px';
    cursor.style.top = e.clientY + 'px';
});

// Scroll Animations
// Scroll Animations
const observerOptions = {
    threshold: 0.1, // Trigger slightly later
    rootMargin: "0px 0px -50px 0px" // Don't trigger until 50px inside viewport (cleaner on mobile)
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            // Determine scroll direction based on position
            const rect = entry.boundingClientRect;
            const windowHeight = window.innerHeight;

            if (rect.top < windowHeight / 2) {
                // Entering from top (scrolling up) -> fade in down
                entry.target.classList.remove('fade-in-up');
                entry.target.classList.add('fade-in-down');
            } else {
                // Entering from bottom (scrolling down) -> fade in up
                entry.target.classList.remove('fade-in-down');
                entry.target.classList.add('fade-in-up');
            }
            entry.target.classList.add('visible');
        } else {
            // Reset state when scrolling away to allow re-animation (Infinite Scroll Effect)
            entry.target.classList.remove('visible');
        }
    });
}, observerOptions);

// Auto-Stagger Grid Animations
document.querySelectorAll('.grid-container, .benefit-cards-grid, .two-column-grid').forEach(grid => {
    const children = grid.children;
    Array.from(children).forEach((child, index) => {
        // Cycle delays: 1, 2, 3, 4, 1, 2...
        const delayNum = (index % 4) + 1;
        child.classList.add(`delay-${delayNum}`);
        child.classList.add('zoom-in'); // Ensure base animation is there
    });
});

// Global Animation Initializer
// Global Animation Initializer - "Reveal on Scroll" for entire website
const animateElements = document.querySelectorAll('h1, h2, h3, h4, h5, h6, p, img, .btn, .btn-primary, .btn-secondary, .btn-cta, .card, .stat-card, .benefit-card, .review-card, .service-item, .project-card, .gallery-item, .vm-card, .about-text, .contact-form, .map-wrapper, .marquee-wrapper, .faq-item, .star-rating');

animateElements.forEach((el, index) => {
    // Exclude FAQ content from animation
    if (el.closest('.faq-answer')) return;

    // Add base class if not present (default to slide-up "Reveal on Scroll")
    if (!el.classList.contains('slide-up') && !el.classList.contains('zoom-in') && !el.classList.contains('slide-in-left') && !el.classList.contains('slide-in-right') && !el.classList.contains('fade-in') && !el.classList.contains('fade-in-up') && !el.classList.contains('fade-in-down')) {
        el.classList.add('fade-in-up');
    }
    // Add observer
    observer.observe(el);
});


// Mobile Scroll Interaction Observer
// Triggers "hover" effects when elements are in the center of the viewport
if (window.innerWidth <= 768) {
    const mobileActiveOptions = {
        threshold: 0.3, // Trigger when 30% visible (easier trigger)
        rootMargin: "-20% 0px -20% 0px" // Active in the middle 60% of the screen
    };

    const mobileActiveObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('scroll-active');
            } else {
                entry.target.classList.remove('scroll-active');
            }
        });
    }, mobileActiveOptions);

    // Elements to animate on scroll
    // Select specific elements that have hover effects we want to trigger
    const mobileInteractiveElements = document.querySelectorAll('.card, .btn-primary, .btn-secondary, .link-styled, .footer-column a, .contact-info a');

    mobileInteractiveElements.forEach(el => {
        mobileActiveObserver.observe(el);
    });
}

// Mobile Menu Toggle

const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', () => {
    navLinks.classList.toggle('active');
});

// Set current year in footer
const yearSpan = document.getElementById('year');
if (yearSpan) {
    yearSpan.textContent = new Date().getFullYear();
}
// Review System Logic
const stars = document.querySelectorAll('input[name="rating"]');
const feedbackForm = document.getElementById('feedback-form');
const reviewCta = document.getElementById('review-cta');
// const feedbackTitle = feedbackForm ? feedbackForm.querySelector('h3') : null; // Removed to prevent crash
// const feedbackText = feedbackForm ? feedbackForm.querySelector('p') : null; // Removed to prevent crash

// Helper to reset iframe logic (fixes reload issue)
// Store pristine templates on load to ensure a fresh start every time
const fourStarTemplate = document.getElementById('four-star-iframe')?.innerHTML;
const negativeTemplate = document.getElementById('negative-review-iframe')?.innerHTML;

// Helper to purely reload content from template (Nuclear Option)
function loadTemplate(containerId, templateContent) {
    const container = document.getElementById(containerId);
    if (!container || !templateContent) return;

    // 1. Reset Content
    container.innerHTML = templateContent;

    // 2. Show Container
    container.classList.remove('hidden');
    container.style.display = 'block';

    // 3. Re-activate Scripts (innerHTML scripts don't run automatically)
    const scripts = container.getElementsByTagName('script');
    Array.from(scripts).forEach(oldScript => {
        const newScript = document.createElement('script');

        // Copy attributes (src, type, etc.)
        Array.from(oldScript.attributes).forEach(attr => newScript.setAttribute(attr.name, attr.value));

        // Copy inline code if any
        newScript.appendChild(document.createTextNode(oldScript.innerHTML));

        // Replace old script with executable new script
        oldScript.parentNode.replaceChild(newScript, oldScript);
    });

    // 4. Scroll into view
    container.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

stars.forEach(star => {
    // Use 'click' instead of 'change' to handle re-clicks on the same rating
    star.addEventListener('click', (e) => {
        const rating = parseInt(e.target.value);

        // Hide all initially
        reviewCta.classList.add('hidden');
        document.getElementById('negative-review-iframe')?.classList.add('hidden');
        document.getElementById('four-star-iframe')?.classList.add('hidden');

        // Small delay to allow UI to update (optional, but keeps transition smooth)
        setTimeout(() => {
            if (rating === 5) {
                // 5 Stars: Show Google Review CTA
                reviewCta.classList.remove('hidden');
                reviewCta.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else if (rating === 4) {
                // 4 Stars: Show New Iframe Form (Instant Show)
                const formContainer = document.getElementById('four-star-iframe');
                if (formContainer) {
                    formContainer.classList.remove('hidden');
                    // Ensure iframe is loaded (if it was lazy loaded or similar, but here it's just hidden)
                    formContainer.style.display = 'block';
                    formContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            } else {
                // 1-3 Stars: Show Negative Iframe Form (Instant Show)
                const formContainer = document.getElementById('negative-review-iframe');
                if (formContainer) {
                    formContainer.classList.remove('hidden');
                    formContainer.style.display = 'block';
                    formContainer.scrollIntoView({ behavior: 'smooth', block: 'center' });
                }
            }
        }, 50);
    });
});

function handleFeedbackSubmit(event) {
    event.preventDefault();
    const email = document.getElementById('feedback-email').value;
    const message = document.getElementById('feedback-message').value;
    const rating = document.querySelector('input[name="rating"]:checked')?.value || 'Unknown';

    const subject = `Feedback from Website (${rating} Stars)`;
    const body = `Rating: ${rating} Stars\nEmail: ${email}\n\nFeedback:\n${message}`;

    // Construct mailto link
    const mailtoLink = `mailto:chat@essenceautomations.com?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`;

    window.location.href = mailtoLink;

    // UI Updates: Show success message and hide form/redundant text
    if (typeof feedbackTitle !== 'undefined') feedbackTitle.textContent = "Thank you for your feedback!";
    // Hide the "Please let us know how we can improve" text
    if (typeof feedbackText !== 'undefined') feedbackText.style.display = 'none';
    // Hide the form itself
    event.target.style.display = 'none';
}
