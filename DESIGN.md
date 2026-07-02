# Blueprint — Travel Times Milwaukee design system

The visual system extracted from the "Blueprint" redesign (`design_handoff_blueprint_landing/`) as implemented in `index.html` + `styles.css`.

**Source of truth:** the `:root` token block at the top of `styles.css`. This document explains intent, usage rules, and recipes; it never overrides the CSS. When they disagree, fix whichever one is wrong and keep both in sync.

**Concept.** A civil-engineering / DOT drawing set. The page is an official document: sections are numbered figures, screenshots sit inside dashed detail callouts, the download CTA is a drawing title block, and the footer base line is a revision strip. The recurring mono labels (`FIG. 01 — …`, `SHEET 3 OF 8`, `DETAIL A`) are not decorative eyebrows; they are the drawing-set convention itself, which is why they may appear on every section without reading as template scaffolding. Anything that couldn't plausibly appear on a blueprint doesn't belong.

---

## 1. Color

### Primitives

| Token | Value | Role |
|---|---|---|
| `--paper` | `#EDF1F9` | Page background ("grid paper") |
| `--surface` | `#FFFFFF` | Cards, panels, nav, alternating white bands |
| `--surface-tint` | `#F5F8FE` | Icon tiles, chips, board/spec chrome |
| `--ink-dark` | `#121D45` | Headings, dark bands, device bezels |
| `--border` | `#C9D4EA` | All panel/card borders, section rules |
| `--border-soft` | `#E3EAF6` | Hairline row separators inside tables |
| `--text` | `#16234E` | Base body, quotes, checklist |
| `--text-body` | `#4A5680` | Paragraphs, secondary copy |
| `--text-muted` | `#586590` | Mono micro-labels, captions |
| `--text-nav` | `#44507A` | Nav + footer links |
| `--blue-primary` | `#16337F` | Solid buttons, logo tile, chip text |
| `--blue-primary-hover` | `#122A6B` | Hover for solid buttons/links |
| `--blue-accent` | `#2B50D8` | Dashed frames, FIG labels, underline, grid lines |
| `--status-green` | `#0F7A4F` | ■ CLEAR |
| `--status-amber` | `#8F6600` | ■ SLOWING |
| `--status-red` | `#C8321F` | ■ CONGESTED |
| `--live-dot` | `#4ADE80` | Pulsing live indicator (on dark only) |
| `--ondark-body` | `#B9C5E4` | Body copy on `--ink-dark` |
| `--ondark-muted` | `#8FA0CB` | Secondary labels on dark |
| `--ondark-faint` | `#7E90BE` | Field labels on dark (large/bold contexts only) |
| `--star-gold` | `#C28B00` | Stars on light |
| `--star-gold-dark` | `#F5C64F` | Stars on dark |
| `--grid-line` | `rgba(43,80,216,.06)` | Grid-paper lines on light |
| `--grid-line-dark` | `rgba(255,255,255,.045)` | Grid-paper lines on dark |

Also in circulation (not tokenized, used once each): `#E8EDF9` dark-card quote text, `#C5D1EC` dark-card attribution, `rgba(255,255,255,.35)` title-block borders.

### Drift from the handoff (intentional — do not "fix" back)

| Token | Handoff | Shipped | Why |
|---|---|---|---|
| `--text-muted` | `#6B7BA8` | `#586590` | 10–12px mono labels must clear WCAG AA (4.5:1) on paper/white |
| `--status-green` | `#1E9E6A` | `#0F7A4F` | Same — status text is small |
| `--status-amber` | `#C28B00` | `#8F6600` | Same; `#C28B00` survives only as `--star-gold` (decorative) |

Rule going forward: any new text color must hit 4.5:1 against the lightest background it appears on (`--surface` `#FFFFFF`). Check before shipping, not after.

### Usage rules

- **Two blues, two jobs.** `--blue-primary` is fills and emphasis text (buttons, logo tile, chips, spec labels). `--blue-accent` is lines and annotation (dashed frames, FIG labels, grid lines, underline, focus rings, icons). Don't swap them.
- **Status colors are semantic only.** Green/amber/red appear exclusively as ■ status squares, the legend, and `[✓]` checks — never as decoration, backgrounds, or pills.
- **Gold is for stars only.**
- **Dark sections** use `--ink-dark` + the on-dark text ramp. `--ondark-faint` is reserved for tiny uppercase field labels; anything sentence-length on dark uses `--ondark-body` or white.

### Grid-paper background

The signature surface. Applied to `body` (light) and the CTA band (dark):

```css
background-color: var(--paper);          /* or --ink-dark */
background-image:
  linear-gradient(var(--grid-line) 1px, transparent 1px),
  linear-gradient(90deg, var(--grid-line) 1px, transparent 1px);
background-size: 24px 24px;              /* dark: --grid-line-dark */
```

White sections are full-bleed `.band--white` overlays on top of it; every band ends with `border-bottom: 1px solid var(--border)`. Sections alternate paper/white down the page (hero paper → strip white → why/features paper → board white → spotlight paper → screens white → reviews paper → about white → CTA ink → footer white). Keep the alternation when adding sections: two same-color bands in a row lose the drawing-sheet rhythm.

---

## 2. Typography

Two families from Google Fonts (preconnect + preload + single stylesheet URL):

- **IBM Plex Sans** 400/500/600/700 — headings, body, buttons, nav
- **IBM Plex Mono** 400/500/600 — every label, index, data value, wordmark

The mono/sans split is the system's grammar: **sans is prose, mono is annotation and data.** If a string is uppercase, numeric, or metadata, it's mono.

### Scale

| Style | Font | Size / weight | Details |
|---|---|---|---|
| H1 hero | Sans 700 | 64px, lh 1.03, ls −1.5px | `--ink-dark`, `text-wrap: balance`; ≤720px: `clamp(2.25rem, 9vw, 2.75rem)` |
| H2 section | Sans 700 | 38px, ls −1px | Why statement 42px · CTA 44px · rating figure 52px; ≤720px: 28px (CTA 32, rating 42) |
| H3 card | Sans 600 | 16.5px | Spotlight H3: 24px |
| Body / lede | Sans 400 | 16–17px, lh 1.6–1.65 | `--text-body`, max-width 44–60ch |
| Card body | Sans 400 | 13.5px, lh 1.55 | |
| FIG label | Mono 400 | 12px, ls 1.5px, UPPER | `--blue-accent` (`.fig`) |
| Micro-label | Mono 400 | 10–11px, ls 1–1.5px, UPPER | `--text-muted` (`.note`, indices, column heads) |
| Data value | Mono 600 | 12–14px | Route names, minutes, spec labels, chips; `font-variant-numeric: tabular-nums` on anything that ticks |
| Field label (dark) | Mono 400 | 9.5px, ls 1.5px, UPPER | `--ondark-faint`, title block only |

Uppercase is label-only (≤ a few words); prose is never uppercase. The `—` and `·` separators inside mono labels (`FIG. 01 — …`, `FREE · NO ADS`) are part of the drawing-annotation voice; keep them in labels, keep them out of body copy.

---

## 3. Space, structure, elevation

- **Container:** max-width 1160px, 24px side padding (`--container-w`, `--container-pad`).
- **Section rhythm:** 64–72px vertical padding. Heading stack spacing: FIG label → 14–16px → title → 10–14px → lede → 30–40px → content grid.
- **Grid gaps:** 14px (feature/review cards) · 18px (screenshots) · 48–56px (two-column story grids).
- **Card padding:** 20–22px.
- **Radii ladder** (small = sharper = more "drafted"): 3px chips · 4px buttons + logo tile · 5px icon tiles · 6px cards · 8px boards/tables/title block · 16–18px dashed callouts · 22px watch bezel · 24px screenshot frames · 38–40px phone bezels.
- **Elevation:** borders do the work; shadows exist only on device imagery and the live board, all in ink at low alpha:
  - hero phone `0 32px 60px -22px rgba(18,29,69,.5)`
  - spotlight phone `0 28px 54px -20px rgba(18,29,69,.45)`
  - live board / mobile nav `0 20px 44px -24px rgba(18,29,69,.3)`
  - watch `0 14px 28px -14px rgba(18,29,69,.5)`
  - Nothing else casts a shadow. Card hover = border-color change, never lift.
- **z-index scale:** header 50, skip link 100 (`--z-header`, `--z-skip`). Extend the scale, don't invent 999s.
- **Breakpoints:** 1024px (story grids collapse, features 4→2, reviews 3→1, footer 4→2) · 720px (hamburger nav, fluid headings, features→1, screenshots→scroll-snap row at 72vw) · 400px (callout edge labels drop).

---

## 4. Signature motifs

These seven patterns are what makes a page read as "Blueprint." Reuse them before inventing anything new.

1. **FIG label** (`.fig`) — every section opens with `FIG. 0N — TITLE` in mono accent. Numbering is sequential down the page and doubles as the sheet narrative (`SHEET 3 OF 8` counter-labels on the right via `.note`).
2. **Dimension line** (`.dim-line`) — 1px accent rule with 9×8px end brackets (3-sided borders) and a centered mono caption (`SCALE 1:1 · DATA: WISDOT · MILWAUKEE, WI`). Hero only; use at most once per page.
3. **Dashed detail callout** (`.callout`) — 1.5px dashed `--blue-accent` frame (radius 16–18px) around device imagery. Mono labels sit ON the frame edge: background matches the section bg, `padding: 0 8px`, top-left label in accent (`DETAIL A — …`), bottom-right in muted (`SRC: …`). Hero variant adds 12×12px solid corner ticks (2px `--blue-primary`). Labels hide below 400px.
4. **Status squares** (`.status--*`) — `■ CLEAR / ■ SLOWING / ■ CONGESTED`, mono 11–12px in the status colors. Never pills, never dots, never color-only.
5. **Numbered indices** — mono muted counters tying content to its section number: features `3.1`–`3.8`, screenshots `6.1`–`6.5`, reviews `REPORT 7.1`–`7.3`. New sections continue the scheme.
6. **Accent underline** (`.underline`) — `box-shadow: inset 0 -3px 0 var(--blue-accent)` on the key phrase of a statement. One per page.
7. **Title block** (`.cta-block`) — the drawing-sheet signature: 1.5px `rgba(255,255,255,.35)` bordered grid on ink, main cell + stacked mono field rows (PROJECT / PRICE / SIZE / DATA / REV). This is the download CTA's identity; reuse the field-row pattern for any future "document metadata" needs.

---

## 5. Components

All live in `styles.css`; class names are the API.

| Component | Classes | Notes |
|---|---|---|
| Buttons | `.btn` + `.btn-primary` / `.btn-secondary` / `.btn-white` + `.btn--nav` / `.btn--md` | Primary: `--blue-primary` fill → hover `--blue-primary-hover`. Secondary: white with **1px dashed accent border** → hover `--surface-tint` fill. White: on dark bands, ink text. Radius 4, weight 600, 44px min-height on coarse pointers |
| Chip | `.chip` | Mono 600 12px `--blue-primary` on `--surface-tint`, 1px border, radius 3, padding 5×12 |
| Feature card | `.feature-card`, `.feature-icon`, `.feature-index` | White, border, radius 6; 38px icon tile (accent stroke-2 SVG on tint) top-left, mono index top-right; hover raises border to accent |
| Live board | `.board`, `.board-head`, `.board-cols`, `.board-row`, `.board-foot` | Ink header with pulsing `.live-dot` + tabular-nums clock; mono column heads; grid rows `1fr 1.3fr auto auto` with `--border-soft` hairlines; tinted footer strip for provenance |
| Spec table | `.spec-table`, `.spec-head`, `.spec-row` | Ink header bar, label/value rows; `dt` mono 600 14px `--blue-primary` min-width 90px |
| Review card | `.review-card` (+ `--dark`) | Stars top-left, mono `REPORT 7.n` top-right, quote, `margin-top:auto` attribution. Dark variant flips to ink + `--star-gold-dark` |
| Device frames | `.device` (+ `--hero`, `--spotlight`), `.watch-frame`, `.shot-frame` | Ink bezel + inner `.device-screen` radius (bezel −9); watch gets a crown nub; screenshots use a light tint frame instead |
| Callout | `.callout` (+ `--spotlight`), `.callout-label--tl/--br`, `.tick-*` | See motif 3 |
| Nav | `.site-header`, `.brand-tile`, `.brand-word`, `.nav-links`, `.nav-toggle` | Sticky white, hairline bottom; typographic TT tile + `TRAVEL_TIMES/MKE` wordmark (`/MKE` in accent); hamburger ≤720px |
| Checklist | `.checklist`, `.check` | Mono `[✓]` in `--status-green` + sans 14.5px item |
| Footer | `.footer-grid`, `.footer-col-head`, `.footer-base` | Mono uppercase column heads; mono base strip |

**Imagery:** every screenshot ships as `.png` + `.webp` in a `<picture>`; real screenshots over CSS mockups, always. iPhone ratio 1320×2868, watch 422×514. Icons are inline SVG, `stroke-width: 2`, `currentColor` — all icons render in `--blue-accent` (single-color; no per-card tints).

---

## 6. Motion

- Easing `--ease: cubic-bezier(.4,0,.2,1)`, `--ease-out: cubic-bezier(.2,.8,.2,1)`; durations `--dur-fast: 150ms`, `--dur-base: 250ms`.
- Hovers transition color/border only (no transform lifts).
- `ttPulse` keyframe on `.live-dot`: opacity 1 → .35 → 1, 1.6s ease-in-out infinite.
- Live ticker (`script.js`): clock every 1s; ~22% chance per tick to nudge one route ±1 min, floor 4.
- Scroll reveal: `[data-reveal]` fade + 16px rise, gated on `html.js` so no-JS visitors see everything.
- `prefers-reduced-motion: reduce` kills smooth scroll, pulse, reveals, and freezes the ticker. Non-negotiable for anything added.

---

## 7. Reusing the system

**New page on this site** (e.g. restyling `privacy.html` / `terms.html` off Tailwind CDN): link `styles.css`, use `.band` / `.band--white` + `.container` for structure, open the content with a `.fig` label, and set body copy in the standard prose styles. The token block + sections 1–4 of `styles.css` (tokens → reset → base → motifs) are the portable core; everything below is per-section.

**New project in this brand:** copy the `:root` block, the grid-paper recipe, the motif classes (`.fig`, `.note`, `.callout`, `.dim-line`, `.status--*`), and the button set. That's the whole identity; the rest is layout.

**Hard rules (the "would it appear on a blueprint?" test):**
- Borders, not shadows. Hairlines structure everything; shadows are device-imagery only.
- Status is a mono ■ square with a text label. Never a pill, never color alone.
- Mono = annotation/data, sans = prose. No third font.
- One accent underline, one dimension line per page.
- No gradients (the grid paper is the only patterned surface), no glassmorphism, no emoji icons.
- New text colors clear 4.5:1 on white before shipping.
