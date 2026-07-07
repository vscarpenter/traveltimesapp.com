// Travel Times Milwaukee — User Guide sheet switcher.
// No dependencies. Progressive: with JS off, all sheets render stacked and
// every in-page link is a normal anchor jump. With JS on, one sheet shows at a
// time; this reconciles the URL hash, moves focus, and announces the change.

(() => {
  const sheets = Array.from(document.querySelectorAll("[data-sheet]"));
  if (sheets.length < 2) return;

  const links = Array.from(document.querySelectorAll("[data-sheet-link]"));
  const counter = document.querySelector("[data-sheet-counter]");
  const status = document.querySelector("[data-sheet-status]");
  const pager = document.querySelector("[data-sheet-nav]");
  const prevLink = document.querySelector("[data-prev]");
  const nextLink = document.querySelector("[data-next]");

  const ids = sheets.map((s) => s.id);
  const total = sheets.length;
  const pad = (n) => String(n).padStart(2, "0");
  const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  // Human title for a sheet, from its heading.
  const titleOf = (sheet) =>
    (sheet.querySelector(".guide-sheet-title")?.textContent || "").trim();

  const setPager = (link, targetId) => {
    if (!link) return;
    if (!targetId) {
      link.hidden = true;
      return;
    }
    const sheet = document.getElementById(targetId);
    link.hidden = false;
    link.setAttribute("href", "#" + targetId);
    const t = link.querySelector(".sn-title");
    if (t) t.textContent = titleOf(sheet);
    // Distinct accessible name per destination (prev vs next both point somewhere).
    link.setAttribute(
      "aria-label",
      (link === prevLink ? "Previous sheet: " : "Next sheet: ") + titleOf(sheet)
    );
  };

  const activate = (id, { focus = false, announce = false } = {}) => {
    let idx = ids.indexOf(id);
    if (idx === -1) idx = 0;
    const activeId = ids[idx];

    sheets.forEach((s, i) => s.classList.toggle("is-active", i === idx));
    links.forEach((a) => {
      const on = a.getAttribute("href") === "#" + activeId;
      if (on) a.setAttribute("aria-current", "true");
      else a.removeAttribute("aria-current");
    });

    if (counter) counter.textContent = `SHEET ${pad(idx + 1)} OF ${pad(total)}`;
    setPager(prevLink, idx > 0 ? ids[idx - 1] : null);
    setPager(nextLink, idx < total - 1 ? ids[idx + 1] : null);
    if (pager) pager.hidden = false;

    if (announce && status) {
      status.textContent = `Sheet ${idx + 1} of ${total}: ${titleOf(sheets[idx])}`;
    }

    if (focus) {
      const heading = sheets[idx].querySelector(".guide-sheet-title");
      if (heading) heading.focus({ preventScroll: true });
      // Bring the sheet top under the sticky header into view.
      sheets[idx].scrollIntoView({
        block: "start",
        behavior: reduced ? "auto" : "smooth",
      });
    }
    return activeId;
  };

  // Navigate to a sheet and record history so Back/Forward walk the sheets.
  const goTo = (id) => {
    const activeId = activate(id, { focus: true, announce: true });
    if (("#" + activeId) !== window.location.hash) {
      history.pushState(null, "", "#" + activeId);
    }
  };

  // Delegated: any in-page link whose target is a sheet switches sheets.
  document.addEventListener("click", (e) => {
    const a = e.target.closest('a[href^="#"]');
    if (!a || e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
    const id = decodeURIComponent(a.getAttribute("href").slice(1));
    if (!ids.includes(id)) return;
    e.preventDefault();
    goTo(id);
  });

  // Back/forward and manual hash edits.
  const syncFromHash = () => {
    const id = decodeURIComponent(window.location.hash.slice(1));
    activate(ids.includes(id) ? id : ids[0], {
      focus: false,
      announce: false,
    });
  };
  window.addEventListener("popstate", syncFromHash);
  window.addEventListener("hashchange", syncFromHash);

  // Initial state — honor a deep link, but don't steal focus on load.
  const initial = decodeURIComponent(window.location.hash.slice(1));
  activate(ids.includes(initial) ? initial : ids[0], { focus: false });
})();
