# Travel Times User Guide page — design

**Date:** 2026-07-07
**Status:** approved
**Source copy:** `user-guide/traveltimesapp-user-guide.md`

## Goal

Convert the markdown user guide into a visually appealing HTML page that matches
the site's "Blueprint" design system and presents the content as discrete
**sections rather than one giant scrolling page**.

## Decisions (approved)

1. **Navigation model:** single page (`guide.html`) with a **sheet switcher**. A
   left-hand SHEET INDEX lists numbered sheets; clicking swaps the visible sheet
   with no reload. Deep-linkable via `#anchors`. Fits the Blueprint "SHEET n OF N"
   drawing-set motif.
2. **Granularity:** ~14 granular per-topic sheets (reference-manual style).
3. **URL & entry:** `guide.html` at repo root (peer of `privacy.html`/`terms.html`);
   linked from the header nav and footer.

## Architecture

- **`guide.html`** — new root page. Reuses the site header + footer; body is a
  two-pane layout (sticky SHEET INDEX + sheet viewport). Loads `styles.css`
  (tokens + motifs), a new `guide.css` (page-only layout), `/script.js` (shared
  behaviours: footer year, mobile-nav toggle, scroll reveal, external-link
  hardening), and a new `guide.js` (the switcher).
- **`guide.css`** — page-only layout: two-pane grid, sticky index, sheet states,
  prev/next controls, responsive collapse (1024 / 720 / 400), reduced-motion.
  No new design tokens; inherits everything from the `:root` block in `styles.css`.
- **`guide.js`** — hash-driven sheet switching; updates the `SHEET n OF 14`
  counter, `aria-current`, prev/next state; moves focus to the active sheet's
  heading and announces via a polite live region.

### Interaction — progressive, deep-linkable, crawlable

- SHEET INDEX items are real `<a href="#id">` anchors.
- **Without JS:** all 14 sheets render stacked (accessible + fully indexable
  fallback). Reuses the existing `html.js` gate — the switcher CSS only hides
  inactive sheets when `.js` is present.
- **With JS:** only the active sheet is shown; inactive sheets get `hidden`
  (removed from tab order + a11y tree). `hashchange` and prev/next drive switches.
- All sheets remain in the DOM so crawlers/LLMs see the full manual.

## The 14 sheets

Own FIG numbering (this is its own drawing set). Each sheet opens with a
`FIG. n —` label + `SHEET n OF 14` counter, a short lede, then content built from
existing components.

| # | Sheet | Content | Screenshot |
|---|---|---|---|
| 01 | Overview | what it is / isn't · Requirements (spec table) | — motifs |
| 02 | Quick Start | 7-step setup (numbered) | — motifs |
| 03 | Reading Routes | route cards · status legend · Last Updated · Refresh · Offline · Search | `iphone-routes`, `iphone-search-airport` |
| 04 | Favorites | add/remove · Favorites tab · reorder/delete | `iphone-favorites` |
| 05 | Route Details | est. arrival · Incidents · Sharing | `iphone-route-detail`, `iphone-route-incidents` |
| 06 | Commute & Route Groups | commute brief · create/edit/delete groups | — motifs |
| 07 | Notifications | schedules · Smart Alerts example · manage | `iphone-notification-schedule` |
| 08 | Live Activities | manual · auto · open-from | reuse real `IMG_4584` Lock Screen |
| 09 | Siri & Shortcuts | phrases · inline "Check my commute" | — motifs |
| 10 | Apple Watch | watch app · complication | reuse real `watch-main` |
| 11 | iPad | split view · context menus · keyboard shortcuts | `ipad-favorites-split-view`, `ipad-route-detail` |
| 12 | Settings | commute / app / data groups | `iphone-settings` |
| 13 | Privacy & Accessibility | no-location · data used · VoiceOver / Dynamic Type | — motifs |
| 14 | Troubleshooting & FAQ | the 8 Q&As as blueprint `<details>` accordions | — motifs |

Component mapping: screenshots → `.callout` dashed detail frames; steps →
numbered lists; "what each card includes" → `.checklist`; requirements + keyboard
shortcuts → `.spec-table`; status → `■ CLEAR / SLOWING / CONGESTED` squares.
**No fake CSS device mockups** — screenshot-less sheets use annotation motifs only.

## Assets

- Copy the 9 guide PNGs from `user-guide/assets/traveltimes-guide/` into
  `assets/guide/`; generate `.webp` pairs (`cwebp -q 82`); shrink oversized PNG
  fallbacks per the CLAUDE.md recipe. Serve via `<picture>` with explicit
  `width/height` + alt text (from the guide captions).
- Reuse existing real device shots for two gap sheets: `assets/IMG_4584.*`
  (Lock Screen) for Live Activities; `assets/watch-main.*` for Apple Watch.

## Integration

- Header nav: add `<a href="/guide.html">Guide</a>`.
- Footer PRODUCT column: add `<li><a href="/guide.html">User guide</a></li>`
  (keeps the existing 4-column grid).
- `guide.html` `<head>`: title + description from the markdown, canonical
  `/guide.html`, OG/Twitter tags (reuse `og-image.png`), and a `FAQPage` JSON-LD
  block for the troubleshooting sheet.
- Add `guide.html` to `sitemap.xml` and `llms.txt`.
- **Deploy allowlist** (`deploy.sh` is fail-closed): add `guide.html` to `PAGES`
  and `guide.css` + `guide.js` to `CODE`. `assets/guide/` deploys via the existing
  `aws s3 sync assets/`.

## Accessibility

- `aria-current="true"` on the active index item; focus moves to the sheet heading
  (`tabindex="-1"`) on switch; polite live-region announcement of the new sheet.
- Inactive sheets `hidden` under JS (out of tab order).
- Full `prefers-reduced-motion` handling (no switch animation; ticker/pulse already
  frozen upstream). No new colors → WCAG AA inherited from pre-corrected tokens.
- Skip link, semantic landmarks, focus-visible outlines, 44×44 touch targets — all
  inherited from `styles.css`.

## Verification

Static site, no test framework. Verify in a real browser: click through all
sheets; deep-link a hash (`#notifications`); disable JS → confirm all sheets
visible (fallback); check responsive at 1024 / 720 / 400; confirm reduced-motion
freezes switch animation; capture before/after screenshots.

## Out of scope (YAGNI)

- No search box over guide content (14-item index is enough).
- No separate print stylesheet.
- No per-sheet standalone URLs beyond hash deep-links.
