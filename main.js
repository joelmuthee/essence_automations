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

document.querySelectorAll('.fade-in-up, .zoom-in, .slide-in-left, .slide-in-right').forEach(el => {
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
