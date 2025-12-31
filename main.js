// Main JS file

// Cursor Effect
const cursor = document.querySelector('.cursor-glow');
document.addEventListener('mousemove', (e) => {
    cursor.style.left = e.clientX + 'px';
    cursor.style.top = e.clientY + 'px';
});

// Scroll Animations
const observerOptions = {
    threshold: 0.1
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            // Check which animation class is present and add proper animation name
            if (entry.target.classList.contains('fade-in-up')) {
                entry.target.style.animationName = 'fadeInUp';
            } else if (entry.target.classList.contains('zoom-in')) {
                entry.target.style.animationName = 'zoomIn';
            } else if (entry.target.classList.contains('slide-in-left')) {
                entry.target.style.animationName = 'slideInLeft';
            } else if (entry.target.classList.contains('slide-in-right')) {
                entry.target.style.animationName = 'slideInRight';
            }

            entry.target.style.opacity = 1;
            entry.target.classList.add('visible');
            // optional: unobserve if you want it to only animate once
            // observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Global Animation Initializer
const animateElements = document.querySelectorAll('.hero h1, .hero p, .hero-buttons, .section-header, .card, .stat-card, .benefit-card, .review-card, .btn-primary, .about-content p');

animateElements.forEach((el, index) => {
    // Add base class if not present
    if (!el.classList.contains('fade-in-up') && !el.classList.contains('zoom-in') && !el.classList.contains('slide-in-left') && !el.classList.contains('slide-in-right')) {
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
