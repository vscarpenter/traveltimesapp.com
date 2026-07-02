// Travel Times Milwaukee — "Blueprint" landing page interactivity
// No dependencies. Progressive: page works without JS.

(() => {
  const prefersReduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  // ---------- 1. Footer year ----------
  const yearEl = document.querySelector("[data-year]");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // ---------- 2. Mobile nav toggle ----------
  const header = document.querySelector("[data-nav]");
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
    // Close on link click or Escape
    document.getElementById("primary-nav")?.addEventListener("click", (e) => {
      if (e.target.tagName === "A") closeNav();
    });
    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") closeNav();
    });
  }

  // ---------- 3. Scroll reveal ----------
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

  // ---------- 4. Live board ticker ----------
  // Clock ticks every second (HH:MM:SS); each tick has ~22% chance to nudge one
  // random route by ±1 min (floor 4). Statuses are fixed. Frozen under reduced motion.
  const clockEl = document.querySelector("[data-clock]");
  const etaEls = Array.from(document.querySelectorAll("[data-eta]"));

  const two = (n) => String(n).padStart(2, "0");
  const fmtClock = (d) => `${two(d.getHours())}:${two(d.getMinutes())}:${two(d.getSeconds())}`;

  if (clockEl) clockEl.textContent = fmtClock(new Date());

  if (clockEl && !prefersReduced) {
    setInterval(() => {
      clockEl.textContent = fmtClock(new Date());

      if (etaEls.length && Math.random() < 0.22) {
        const b = etaEls[Math.floor(Math.random() * etaEls.length)];
        const current = parseInt(b.textContent, 10) || 4;
        const next = Math.max(4, current + (Math.random() < 0.5 ? -1 : 1));
        b.textContent = next;
      }
    }, 1000);
  }

  // ---------- 5. Safe external link hardening ----------
  document.querySelectorAll('a[target="_blank"]').forEach((a) => {
    const rel = (a.getAttribute("rel") || "").split(/\s+/);
    if (!rel.includes("noopener"))   rel.push("noopener");
    if (!rel.includes("noreferrer")) rel.push("noreferrer");
    a.setAttribute("rel", rel.filter(Boolean).join(" "));
  });
})();
