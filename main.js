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
            entry.target.classList.add('visible');
            // no inline styles needed, CSS handles it
        }
    });
}, observerOptions);

// Global Animation Initializer
const animateElements = document.querySelectorAll('.hero h1, .hero p, .hero-buttons, .section-header, .card, .stat-card, .benefit-card, .review-card, .btn-primary, .about-content p');

animateElements.forEach((el, index) => {
    // Add base class if not present (default to slide-up now)
    if (!el.classList.contains('slide-up') && !el.classList.contains('zoom-in') && !el.classList.contains('slide-in-left') && !el.classList.contains('slide-in-right') && !el.classList.contains('fade-in')) {
        el.classList.add('slide-up');
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
