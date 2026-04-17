// Travel Times Milwaukee — landing page interactivity
// No dependencies. Progressive: page works without JS.

(() => {
  const prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  // ---------- 1. Footer year ----------
  const yearEl = document.querySelector("[data-year]");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // ---------- 2. Header scroll shadow ----------
  const header = document.querySelector("[data-nav]");
  if (header) {
    const onScroll = () => header.dataset.scrolled = window.scrollY > 8;
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
  }

  // ---------- 3. Mobile nav toggle ----------
  const navToggle = document.querySelector("[data-nav-toggle]");
  if (navToggle && header) {
    const closeNav = () => {
      header.removeAttribute("data-nav-open");
      navToggle.setAttribute("aria-expanded", "false");
      navToggle.setAttribute("aria-label", "Open menu");
    };
    const openNav = () => {
      header.setAttribute("data-nav-open", "true");
      navToggle.setAttribute("aria-expanded", "true");
      navToggle.setAttribute("aria-label", "Close menu");
    };
    navToggle.addEventListener("click", () => {
      navToggle.getAttribute("aria-expanded") === "true" ? closeNav() : openNav();
    });
    // Close on link click or escape
    document.getElementById("primary-nav")?.addEventListener("click", (e) => {
      if (e.target.tagName === "A") closeNav();
    });
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") closeNav();
    });
  }

  // ---------- 4. Scroll reveal ----------
  const revealEls = document.querySelectorAll("[data-reveal]");
  if (revealEls.length && "IntersectionObserver" in window && !prefersReduced) {
    const io = new IntersectionObserver((entries) => {
      for (const entry of entries) {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          io.unobserve(entry.target);
        }
      }
    }, { rootMargin: "0px 0px -10% 0px", threshold: 0.1 });
    revealEls.forEach((el) => io.observe(el));
  } else {
    revealEls.forEach((el) => el.classList.add("is-visible"));
  }

  // ---------- 5. Screenshot carousel ----------
  const carousel = document.querySelector("[data-carousel]");
  if (carousel) {
    const track = carousel.querySelector("[data-track]");
    const slides = Array.from(track.children);
    const prevBtn = carousel.querySelector("[data-prev]");
    const nextBtn = carousel.querySelector("[data-next]");
    const dotsContainer = carousel.querySelector("[data-dots]");

    // Build dots
    slides.forEach((_, i) => {
      const b = document.createElement("button");
      b.type = "button";
      b.setAttribute("role", "tab");
      b.setAttribute("aria-label", `Go to screenshot ${i + 1}`);
      if (i === 0) b.setAttribute("aria-current", "true");
      b.addEventListener("click", () => scrollToSlide(i));
      dotsContainer.appendChild(b);
    });
    const dots = Array.from(dotsContainer.children);

    const scrollToSlide = (i) => {
      const target = slides[i];
      if (!target) return;
      const left = target.offsetLeft - (track.clientWidth - target.clientWidth) / 2;
      track.scrollTo({ left, behavior: prefersReduced ? "auto" : "smooth" });
    };

    const activeIndex = () => {
      const center = track.scrollLeft + track.clientWidth / 2;
      let best = 0, bestDist = Infinity;
      slides.forEach((s, i) => {
        const c = s.offsetLeft + s.clientWidth / 2;
        const d = Math.abs(c - center);
        if (d < bestDist) { bestDist = d; best = i; }
      });
      return best;
    };

    const updateDots = () => {
      const idx = activeIndex();
      dots.forEach((d, i) => {
        if (i === idx) d.setAttribute("aria-current", "true");
        else d.removeAttribute("aria-current");
      });
    };

    let raf;
    track.addEventListener("scroll", () => {
      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(updateDots);
    }, { passive: true });

    prevBtn?.addEventListener("click", () => scrollToSlide(Math.max(0, activeIndex() - 1)));
    nextBtn?.addEventListener("click", () => scrollToSlide(Math.min(slides.length - 1, activeIndex() + 1)));

    // Keyboard nav on track
    track.tabIndex = 0;
    track.addEventListener("keydown", (e) => {
      if (e.key === "ArrowRight") { e.preventDefault(); nextBtn.click(); }
      if (e.key === "ArrowLeft")  { e.preventDefault(); prevBtn.click(); }
    });

    // Center first slide initially (after layout)
    requestAnimationFrame(() => scrollToSlide(0));
  }

  // ---------- 6. Live demo ticker ----------
  const routesEl = document.querySelector("[data-routes]");
  const clockEl = document.querySelector("[data-clock]");

  const fmtClock = (d) =>
    d.toLocaleTimeString([], { hour: "numeric", minute: "2-digit" }) + " CT";

  if (clockEl) {
    clockEl.textContent = fmtClock(new Date());
    setInterval(() => { clockEl.textContent = fmtClock(new Date()); }, 30_000);
  }

  if (routesEl && !prefersReduced) {
    const items = Array.from(routesEl.querySelectorAll("li"));

    const statusFor = (value, baseline) => {
      const ratio = value / baseline;
      if (ratio < 1.15) return "green";
      if (ratio < 1.5)  return "yellow";
      return "red";
    };

    const applyStatus = (li, status, etaValue) => {
      li.dataset.status = status;
      const dot = li.querySelector(".dot");
      dot.classList.remove("dot-green", "dot-yellow", "dot-red");
      dot.classList.add(`dot-${status}`);
      const etaB = li.querySelector("[data-eta]");
      etaB.textContent = etaValue;
      li.dataset.tick = "true";
      setTimeout(() => { li.dataset.tick = "false"; }, 500);
    };

    const tickRoute = () => {
      // Pick one route at random to update, simulating realistic pacing
      const li = items[Math.floor(Math.random() * items.length)];
      const baseline = Number(li.dataset.baseline);
      // Drift ±25% around baseline, skewed slightly slower
      const drift = 0.75 + Math.random() * 0.6;
      const value = Math.max(1, Math.round(baseline * drift));
      applyStatus(li, statusFor(value, baseline), value);
    };

    setInterval(tickRoute, 4_500);
  }

  // ---------- 7. Safe external link hardening ----------
  document.querySelectorAll('a[target="_blank"]').forEach((a) => {
    const rel = (a.getAttribute("rel") || "").split(/\s+/);
    if (!rel.includes("noopener"))   rel.push("noopener");
    if (!rel.includes("noreferrer")) rel.push("noreferrer");
    a.setAttribute("rel", rel.filter(Boolean).join(" "));
  });
})();
