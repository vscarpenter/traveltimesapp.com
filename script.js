document.addEventListener('DOMContentLoaded', () => {
    const toggle = document.querySelector('.nav__toggle');
    const menu = document.querySelector('.nav__menu');
    const header = document.querySelector('.site-header');

    if (toggle && menu) {
        toggle.addEventListener('click', () => {
            const expanded = toggle.getAttribute('aria-expanded') === 'true';
            toggle.setAttribute('aria-expanded', String(!expanded));
            menu.classList.toggle('is-open', !expanded);
        });

        menu.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', () => {
                toggle.setAttribute('aria-expanded', 'false');
                menu.classList.remove('is-open');
            });
        });
    }

    const handleScroll = () => {
        if (!header) return;
        if (window.scrollY > 12) {
            header.classList.add('is-scrolled');
        } else {
            header.classList.remove('is-scrolled');
        }
    };

    handleScroll();
    window.addEventListener('scroll', handleScroll, { passive: true });

    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', event => {
            const href = anchor.getAttribute('href');
            if (!href || href === '#') return;
            const id = href.slice(1);
            if (!/^[a-zA-Z0-9-]+$/.test(id)) return;
            const target = document.getElementById(id);
            if (!target) return;

            event.preventDefault();
            const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            const top = target.getBoundingClientRect().top + window.pageYOffset - 72;
            if (prefersReduced) {
                window.scrollTo(0, top);
            } else {
                window.scrollTo({ top, behavior: 'smooth' });
            }
        });
    });

    const revealables = document.querySelectorAll('.feature-card, .preview__frame, .voice, .story__stat, .callout');
    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (!prefersReduced && revealables.length) {
        revealables.forEach(el => el.classList.add('reveal'));

        const observer = new IntersectionObserver(entries => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-visible');
                    observer.unobserve(entry.target);
                }
            });
        }, {
            threshold: 0.2,
            rootMargin: '0px 0px -10% 0px'
        });

        revealables.forEach(el => observer.observe(el));
    }
});
