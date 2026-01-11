// Main JS file

// Cursor Effect
const cursor = document.querySelector('.cursor-glow');
document.addEventListener('mousemove', (e) => {
    cursor.style.left = e.clientX + 'px';
    cursor.style.top = e.clientY + 'px';
});

// Scroll Animations
const observerOptions = {
    threshold: 0.05
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
            // Reset state when scrolling away to allow re-animation
            entry.target.classList.remove('visible');
        }
    });
}, observerOptions);

// Global Animation Initializer
// Global Animation Initializer - "Reveal on Scroll" for entire website
const animateElements = document.querySelectorAll('h1, h2, h3, h4, h5, h6, p, img, .btn, .btn-primary, .btn-outline, .btn-cta, .card, .stat-card, .benefit-card, .review-card, .service-item, .project-card, .gallery-item, .vm-card, .about-text, .contact-form, .map-wrapper, .marquee-wrapper, .faq-item, .star-rating');

animateElements.forEach((el, index) => {
    // Exclude FAQ content from animation
    if (el.closest('.faq-answer')) return;

    // Add base class if not present (default to slide-up "Reveal on Scroll")
    if (!el.classList.contains('slide-up') && !el.classList.contains('zoom-in') && !el.classList.contains('slide-in-left') && !el.classList.contains('slide-in-right') && !el.classList.contains('fade-in') && !el.classList.contains('fade-in-up')) {
        el.classList.add('fade-in-up');
    }
    // Add observer
    observer.observe(el);
});


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

stars.forEach(star => {
    star.addEventListener('change', (e) => {
        const rating = parseInt(e.target.value);

        // Hide both initially with specific class handling
        feedbackForm.classList.add('hidden');
        reviewCta.classList.add('hidden');

        // Small delay to allow transition if needed, or immediate
        setTimeout(() => {
            if (rating === 5) {
                reviewCta.classList.remove('hidden');
                // Optional: Scroll to it
                reviewCta.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                feedbackForm.classList.remove('hidden');
                feedbackForm.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }, 100);
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

    // Optional: Show "Sent" state
    event.target.innerHTML = '<h3>Thank you for your feedback!</h3>';
}
