// Mobile Navigation Toggle
document.addEventListener('DOMContentLoaded', function() {
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.querySelector('.nav-links');
    
    if (navToggle && navLinks) {
        navToggle.addEventListener('click', function() {
            navLinks.classList.toggle('active');
            navToggle.classList.toggle('active');
        });
    }
    
    // Close mobile menu when clicking on a link
    const navLinksItems = document.querySelectorAll('.nav-links a');
    navLinksItems.forEach(link => {
        link.addEventListener('click', function() {
            navLinks.classList.remove('active');
            navToggle.classList.remove('active');
        });
    });
});

// Smooth scrolling for anchor links with security validation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const href = this.getAttribute('href');
        
        // Validate href to prevent potential XSS
        if (href && href.startsWith('#') && href.length > 1) {
            const targetId = href.substring(1);
            // Only allow alphanumeric characters and hyphens in IDs
            if (/^[a-zA-Z0-9-]+$/.test(targetId)) {
                const target = document.getElementById(targetId);
                if (target) {
                    const offsetTop = target.offsetTop - 70; // Account for fixed navbar
                    window.scrollTo({
                        top: offsetTop,
                        behavior: 'smooth'
                    });
                }
            }
        }
    });
});

// Navbar background change on scroll
window.addEventListener('scroll', function() {
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(255, 255, 255, 0.98)';
            navbar.style.boxShadow = '0 2px 20px rgba(0, 0, 0, 0.1)';
        } else {
            navbar.style.background = 'rgba(255, 255, 255, 0.95)';
            navbar.style.boxShadow = 'none';
        }
    }
});

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting && entry.target) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for animation
document.addEventListener('DOMContentLoaded', function() {
    const animatedElements = document.querySelectorAll('.feature-card, .review-card, .download-content, .about-content');
    
    animatedElements.forEach(el => {
        if (el) {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            observer.observe(el);
        }
    });
});

// Parallax effect for hero section
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const hero = document.querySelector('.hero');
    const heroBackground = document.querySelector('.hero-background');
    
    if (hero && heroBackground) {
        const rate = scrolled * -0.5;
        heroBackground.style.transform = `translateY(${rate}px)`;
    }
});

// Add loading animation to page
window.addEventListener('load', function() {
    document.body.classList.add('loaded');
    
    // Trigger hero animations
    const heroContent = document.querySelector('.hero-content');
    if (heroContent) {
        heroContent.style.opacity = '1';
        heroContent.style.transform = 'translateY(0)';
    }
    
    // Stagger feature card animations
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach((card, index) => {
        setTimeout(() => {
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
});

// Track download button clicks with security validation
document.addEventListener('DOMContentLoaded', function() {
    const downloadButtons = document.querySelectorAll('.cta-button, .download-button');
    
    downloadButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Validate href before opening
            const href = this.getAttribute('href');
            if (href && (href.startsWith('https://itunes.apple.com') || href.startsWith('https://apps.apple.com'))) {
                // You can add analytics tracking here
                console.log('Download button clicked');
                
                // Open in new tab with security attributes
                const newWindow = window.open(href, '_blank', 'noopener,noreferrer');
                if (newWindow) {
                    newWindow.opener = null;
                }
            }
        });
    });
});

// Add CSS for mobile navigation with sanitized content
const style = document.createElement('style');
style.textContent = `
    @media (max-width: 768px) {
        .nav-links {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            flex-direction: column;
            padding: 1rem;
            border-top: 1px solid var(--border-color);
            box-shadow: var(--shadow-lg);
            transform: translateY(-100%);
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        }
        
        .nav-links.active {
            transform: translateY(0);
            opacity: 1;
            visibility: visible;
        }
        
        .nav-toggle.active span:nth-child(1) {
            transform: rotate(45deg) translate(5px, 5px);
        }
        
        .nav-toggle.active span:nth-child(2) {
            opacity: 0;
        }
        
        .nav-toggle.active span:nth-child(3) {
            transform: rotate(-45deg) translate(7px, -6px);
        }
    }
    
    .loaded .hero-content {
        animation: fadeInUp 0.8s ease-out;
    }
    
    .loaded .feature-card {
        animation: fadeInUp 0.6s ease-out;
    }
    
    .loaded .review-card {
        animation: fadeInUp 0.6s ease-out;
    }
`;

// Safely append style to head
if (document.head) {
    document.head.appendChild(style);
}

// Screenshot Carousel Functionality
document.addEventListener('DOMContentLoaded', function() {
    const track = document.getElementById('screenshot-track');
    const slides = document.querySelectorAll('.screenshot-slide');
    const indicators = document.querySelectorAll('.indicator');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    
    let currentSlide = 0;
    
    function updateCarousel() {
        // Update slides
        slides.forEach((slide, index) => {
            slide.classList.toggle('active', index === currentSlide);
        });
        
        // Update indicators
        indicators.forEach((indicator, index) => {
            indicator.classList.toggle('active', index === currentSlide);
        });
        
        // Update track position
        if (track) {
            track.style.transform = `translateX(-${currentSlide * 100}%)`;
        }
    }
    
    function nextSlide() {
        currentSlide = (currentSlide + 1) % slides.length;
        updateCarousel();
    }
    
    function prevSlide() {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        updateCarousel();
    }
    
    // Event listeners
    if (nextBtn) {
        nextBtn.addEventListener('click', nextSlide);
    }
    
    if (prevBtn) {
        prevBtn.addEventListener('click', prevSlide);
    }
    
    // Indicator clicks
    indicators.forEach((indicator, index) => {
        indicator.addEventListener('click', () => {
            currentSlide = index;
            updateCarousel();
        });
    });
    
    // Auto-play carousel
    setInterval(nextSlide, 5000);
    
    // Initialize carousel
    updateCarousel();
});

// Enhanced Feature Card Interactions
document.addEventListener('DOMContentLoaded', function() {
    const featureCards = document.querySelectorAll('.feature-card');
    
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            // Add glow effect
            const feature = this.getAttribute('data-feature');
            if (feature === 'realtime') {
                this.style.boxShadow = '0 20px 40px rgba(0, 122, 255, 0.3)';
            } else if (feature === 'favorites') {
                this.style.boxShadow = '0 20px 40px rgba(255, 107, 53, 0.3)';
            }
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.boxShadow = '';
        });
    });
});

// Enhanced Timeline Animation
document.addEventListener('DOMContentLoaded', function() {
    const timelineSteps = document.querySelectorAll('.timeline-step');
    
    const observerOptions = {
        threshold: 0.8,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const timelineObserver = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Animate timeline steps in sequence
                timelineSteps.forEach((step, index) => {
                    setTimeout(() => {
                        step.style.opacity = '1';
                        step.style.transform = 'translateX(0)';
                        
                        // Add active class to first step
                        if (index === 0) {
                            step.classList.add('active');
                        }
                    }, index * 200);
                });
            }
        });
    }, observerOptions);
    
    const timeline = document.querySelector('.journey-timeline');
    if (timeline) {
        // Initially hide steps
        timelineSteps.forEach(step => {
            step.style.opacity = '0';
            step.style.transform = 'translateX(-50px)';
            step.style.transition = 'all 0.6s ease';
        });
        
        timelineObserver.observe(timeline);
    }
});

// Floating Elements Animation Enhancement
document.addEventListener('DOMContentLoaded', function() {
    const floatingIcons = document.querySelectorAll('.floating-icon');
    
    // Add random movement to floating icons
    floatingIcons.forEach((icon, index) => {
        setInterval(() => {
            const randomX = (Math.random() - 0.5) * 20;
            const randomY = (Math.random() - 0.5) * 20;
            icon.style.transform = `translateX(${randomX}px) translateY(${randomY}px) rotate(${Math.random() * 10}deg)`;
        }, 3000 + index * 500);
    });
});

// Enhanced Scroll Animations
window.addEventListener('scroll', function() {
    const scrolled = window.pageYOffset;
    const rate = scrolled * -0.5;
    
    // Enhanced parallax for hero background
    const heroBackground = document.querySelector('.hero-background');
    if (heroBackground) {
        heroBackground.style.transform = `translateY(${rate}px)`;
    }
    
    // Floating shapes parallax
    const shapes = document.querySelectorAll('.shape');
    shapes.forEach((shape, index) => {
        const speed = 0.2 + (index * 0.1);
        const yPos = -(scrolled * speed);
        shape.style.transform = `translateY(${yPos}px) rotate(${scrolled * 0.1}deg)`;
    });
    
    // Phone mockup gentle parallax
    const phoneScreen = document.querySelector('.phone-screen');
    if (phoneScreen) {
        const parallaxRate = scrolled * 0.1;
        phoneScreen.style.transform = `translateY(${parallaxRate}px)`;
    }
}); 