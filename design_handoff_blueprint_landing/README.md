# Handoff: Travel Times Milwaukee — "Blueprint" Landing Page Redesign

## Overview
A full visual redesign of the traveltimesapp.com landing page in a **"Blueprint" aesthetic**: a civil-engineering / DOT drawing-set language. Grid paper background, ink-navy headings, blueprint-blue dashed callouts, monospace figure labels (`FIG. 01 — …`), status squares (■), dimension lines, and a download CTA styled as a drawing title block. It replaces the current indigo/cream design (Outfit / Work Sans / Playfair) while preserving all existing content, copy, links, and section order.

## About the Design Files
The bundled `Landing — Blueprint.dc.html` is a **design reference created in HTML** — a prototype showing intended look and behavior, not production code to copy directly. The task is to **recreate this design in the existing traveltimesapp.com codebase**: a no-build static site (vanilla `index.html` + `styles.css` + `script.js`, deployed to S3/CloudFront). Concretely: replace the design tokens and component styles in `styles.css`, update markup patterns in `index.html`, and keep/adapt the behaviors in `script.js`. Do not introduce a framework or build step.

Preserve as-is from the current site:
- All `<head>` SEO: meta description, Open Graph, Twitter cards, JSON-LD structured data, canonical URL (update `theme-color` to `#16337F`)
- All accessibility commitments: skip link, semantic landmarks, alt text, visible focus states, 44×44 touch targets, WCAG AA contrast, `prefers-reduced-motion`
- All URLs (App Store link with `pt`/`ct` params, vinny.dev, x.com/traveltimesapp, privacy.html, terms.html)
- Asset paths (`/assets/…`) — every image used already exists in the repo

## Fidelity
**High-fidelity for desktop (≥1024px).** Colors, typography, spacing, and copy are final — recreate pixel-perfectly. **Responsive behavior is low-fidelity**: the prototype is desktop-only; adapt the mobile/tablet layouts using the current site's existing breakpoints and nav-toggle pattern, following the guidance in "Responsive behavior" below.

## Design Tokens

Replace the `:root` token block in `styles.css` with these (keep the existing token *naming conventions* where convenient):

### Colors
```css
/* Surfaces */
--paper:        #EDF1F9;  /* page background ("grid paper") */
--surface:      #FFFFFF;  /* cards, panels, nav, alternating sections */
--surface-tint: #F5F8FE;  /* icon tiles, chips, board header rows */
--ink-dark:     #121D45;  /* headings, dark sections, phone bezels */

/* Lines */
--border:       #C9D4EA;  /* all panel/card borders, section rules */
--border-soft:  #E3EAF6;  /* hairline row separators inside tables */

/* Text */
--text:         #16234E;  /* base body */
--text-body:    #4A5680;  /* paragraphs, secondary */
--text-muted:   #6B7BA8;  /* mono micro-labels, captions */
--text-nav:     #44507A;  /* nav + footer links */

/* Brand */
--blue-primary: #16337F;  /* solid buttons, logo tile, chip text */
--blue-accent:  #2B50D8;  /* dashed borders, FIG labels, underline accent, grid lines */

/* Traffic status */
--status-green: #1E9E6A;
--status-amber: #C28B00;
--status-red:   #C8321F;
--live-dot:     #4ADE80;  /* pulsing "live" indicator on dark */

/* On-dark (CTA band, board header, dark review card) */
--ondark-body:  #B9C5E4;
--ondark-muted: #8FA0CB;
--ondark-faint: #7E90BE;
--star-gold:    #C28B00;  /* stars on light */
--star-gold-dark: #F5C64F; /* stars on dark */
```

### Grid-paper background
Applied to `body` and to the dark CTA band (lighter lines there):
```css
/* light sections */
background-color: #EDF1F9;
background-image:
  linear-gradient(rgba(43,80,216,.06) 1px, transparent 1px),
  linear-gradient(90deg, rgba(43,80,216,.06) 1px, transparent 1px);
background-size: 24px 24px;

/* dark CTA band: same but rgba(255,255,255,.045) */
```
White sections (`--surface`) sit on top as full-bleed bands with `border-bottom: 1px solid var(--border)` — sections alternate paper/white: Hero (paper) → Freeway strip (white) → Why (paper) → Features (paper) → Live board (white) → Spotlight (paper) → Screenshots (white) → Reviews (paper) → About (white) → CTA (ink dark) → Footer (white).

### Typography
Google Fonts (replace current font links):
```
IBM Plex Sans: 400, 500, 600, 700
IBM Plex Mono: 400, 500, 600
```
- Body: `'IBM Plex Sans', sans-serif`, 16–17px, line-height 1.6–1.65, color `--text-body`
- **H1 (hero)**: Plex Sans 700, 64px, line-height 1.03, letter-spacing −1.5px, color `--ink-dark`
- **H2 (sections)**: Plex Sans 700, 38px (Why statement: 42px; CTA: 44px; Reviews "4.8": 52px), letter-spacing −1px, color `--ink-dark`
- **H3 (cards)**: Plex Sans 600, 16.5px (spotlight H3: 24px)
- **Mono micro-labels** (`FIG. 0N — …`, `SHEET 3 OF 8`, table headers, chips): Plex Mono 400–600, 10–12px, letter-spacing 1–2px, UPPERCASE, color `--blue-accent` for FIG labels / `--text-muted` for secondary labels
- **Data values** (route names, minutes, spec values): Plex Mono 600, 12–14px
- Feature/figure body copy: 13.5px, line-height 1.55

### Spacing & layout
- Container: max-width **1160px**, side padding 24px
- Section vertical padding: **64–72px**
- Card grid gaps: 14px (features, reviews), 18px (screenshots)
- Card padding: 20–22px
- Nav height: ~56px (14px vertical padding), **sticky**, white, `border-bottom: 1px solid var(--border)`, z-index 50

### Radii
- Chips/network tags: 3px · Buttons + logo tile: 4px · Icon tiles: 5px · Cards: 6px · Boards/spec tables/CTA block: 8px · Dashed callout frames: 16–18px · Phone bezels: 38–40px · Watch bezel: 22px

### Shadows
- Hero phone: `0 32px 60px -22px rgba(18,29,69,.5)`
- Spotlight phone: `0 28px 54px -20px rgba(18,29,69,.45)`
- Live board: `0 20px 44px -24px rgba(18,29,69,.3)`
- Watch: `0 14px 28px -14px rgba(18,29,69,.5)`
- Everything else is flat — borders, not shadows, do the work in this aesthetic.

## Signature Blueprint Motifs (reused across sections)

1. **FIG label**: every section opens with Plex Mono 12px, letter-spacing 1.5px, `--blue-accent`: `FIG. 01 — REAL-TIME COMMUTE INTELLIGENCE`, `FIG. 02 — GENERAL NOTES`, `FIG. 03 — BUILT FOR COMMUTERS`, `FIG. 04 — A PEEK AT THE LIVE BOARD`, `FIG. 05 — NEW THIS RELEASE`, `FIG. 06 — INSIDE THE APP`, `FIG. 07 — FIELD REPORTS`, `FIG. 08 — THE STORY`.
2. **Dimension line** (hero only): a horizontal 1px `--blue-accent` rule with 9×8px end brackets (borders on 3 sides) and a centered mono caption `SCALE 1:1 · DATA: WISDOT · MILWAUKEE, WI`.
3. **Dashed detail callout**: 1.5px dashed `--blue-accent` frame (radius 16–18px) around device images, with mono labels sitting ON the frame edge (background matches section bg, `padding: 0 8px`): top-left `DETAIL A — LIVE ROUTE LIST`, bottom-right `SRC: WISDOT FEED · REV 2.4`. Hero adds 12×12px solid corner ticks (2px `--blue-primary` borders) at all four corners.
4. **Status squares**: `■ CLEAR` / `■ SLOWING` / `■ CONGESTED` in Plex Mono 11px in the status colors — never colored pills or dots.
5. **Numbered items**: features carry mono indices `3.1`–`3.8` top-right; screenshots `6.1`–`6.5`; reviews `REPORT 7.1`–`7.3`.
6. **Accent underline**: key phrase in the Why statement gets `box-shadow: inset 0 -3px 0 var(--blue-accent)`.

## Screens / Sections (top to bottom)

### 1. Nav (sticky)
- Logo: 28×28px `--blue-primary` tile, radius 4, white Plex Mono 600 12px "TT" centered + wordmark `TRAVEL_TIMES/MKE` (Plex Mono 600 14px; `/MKE` in `--blue-accent`)
- Links (right-aligned, 22px gap, Plex Sans 600 13.5px, `--text-nav`): Features · Live board · App · Reviews · Story
- Download button: `--blue-primary` bg, white, 600 13.5px, padding 9×18, radius 4

### 2. Hero (paper bg)
Two-column grid `1.05fr / .95fr`, 48px gap, padding 64/56px vertical.
- Left: FIG 01 label → H1 "Never miss your route" → dimension line → lede (17px, `--text-body`, max 48ch): "Real-time travel times for every major Milwaukee freeway — on your phone, your wrist, and your Lock Screen. Free, ad-free, and powered by official WisDOT data." → CTAs → mono trust row `★ 4.8 APP STORE  ·  FREE · NO ADS  ·  NO TRACKING` (11px, `--text-muted`)
- CTAs: primary = Apple logo SVG + "Download for iOS", `--blue-primary`, padding 13×24, radius 4; secondary = "See features", white bg, **1px dashed `--blue-accent`**, `--blue-primary` text
- Right: dashed callout (motif 3, with corner ticks) framing an iPhone: 264px wide, `--ink-dark` bezel, 10px padding, radius 40 (screen 31), screenshot `/assets/IMG_4571.png`

### 3. Freeway strip (white band)
Single row: mono label `NETWORK COVERAGE:` + chips `I-94  I-43  I-894  US-45  I-41  I-794  I-39/90` (Plex Mono 600 12px, `--blue-primary` on `--surface-tint`, 1px `--border`, radius 3, padding 5×12) + right-aligned `■ FEED OPERATIONAL` in `--status-green`.

### 4. Why (paper)
FIG 02 — GENERAL NOTES + statement (Plex Sans 700 42px, max 26ch): "No clutter. No distractions. Just the information you need to ~~make the right route choice.~~" — underlined phrase per motif 6.

### 5. Features (paper)
FIG 03 + H2 "Everything you need. Nothing you don't." + right-aligned mono `SHEET 3 OF 8` + lede "Hyperlocal traffic intelligence, stripped down to the signal."
Grid: **4 columns × 2 rows**, 14px gap. Card: white, 1px `--border`, radius 6, padding 20. Inside: 38px icon tile (`--surface-tint` bg, 1px `--border`, radius 5, 20px stroke icon in `--blue-accent`) top-left, mono index top-right, H3 + 13.5px body below. Keep the existing 8 feature titles/copy and their SVG icons (stroke-width 2, currentColor) — icons all become `--blue-accent` (drop the current per-card `--tint` rainbow).

### 6. Live board (white)
Two-column `1fr / 1.05fr`, 52px gap.
- Left: FIG 04 + H2 "Watch travel times update in real time." + copy + mono legend row: `■ CLEAR` `■ SLOWING` `■ CONGESTED` in their colors
- Right: board panel (radius 8, 1px `--border`, board shadow): header bar `--ink-dark` with pulsing 8px `--live-dot` dot + `LIVE BOARD — MKE NETWORK` + right-aligned live clock `HH:MM:SS`; mono column-header row `SEGMENT / SPAN / STATUS / EST` (10px, `--text-muted`, `--surface-tint`); 4 data rows (grid `1fr 1.3fr auto auto`, hairline separators): I-94 EB Downtown→Airport ■ CLEAR 10 MIN · I-894 NB Greenfield→Zoo Int ■ CLEAR 14 MIN · I-43 SB Glendale→Downtown ■ SLOWING 22 MIN · I-894 WB Zoo Int→Hale ■ CONGESTED 31 MIN; footer strip `DEMO DATA — ILLUSTRATIVE ONLY · SRC: WISDOT SENSOR FEED`

### 7. Spotlight — Live Activities (paper)
FIG 05 + H2 "Live Activities, now in the Dynamic Island." + lede. Grid `auto / 1fr`, 56px gap:
- Left: dashed callout `DETAIL B — LOCK SCREEN` framing 248px phone with `/assets/IMG_4584.png`
- Right: H3 "Glance. Never unlock." + paragraph + checklist (three rows, mono `[✓]` in `--status-green` + Plex Sans 14.5px): Lock Screen Live Activities / Dynamic Island support / Scheduled push notifications
- Below right: **watch card** (white, 1px `--border`, radius 8, padding 18×22, max 520px): 96px watch (ink bezel radius 22, crown nub, `/assets/watch-main.png`) + `DETAIL C — WRIST UNIT` label + "Full Apple Watch app" + one-liner

### 8. Screenshots (white)
FIG 06 + H2 "Designed for a single glance at the stoplight." Then **5-up grid** (replaces the current JS carousel), 18px gap. Each figure: screenshot in a light frame (1px `--border`, radius 24, padding 6, `--surface-tint`), caption below = mono index + 600 title + 12px description. Order: 6.1 Main overview (IMG_4571) · 6.2 Color-coded status (IMG_4572) · 6.3 Route details (IMG_4574) · 6.4 Pinned favorites (IMG_4576) · 6.5 Scheduled alerts (IMG_4581). On mobile this becomes a horizontal scroll-snap row (see Responsive) — the carousel JS can be retired or kept for mobile only.

### 9. Reviews (paper)
FIG 07 — FIELD REPORTS + "4.8" (52px) + gold stars + mono `APP STORE RATING` + lede. 3-column grid of review cards (white, border, radius 6, padding 22): stars top-left (`--star-gold`), mono `REPORT 7.n` top-right, quote 15px/1.6, attribution 12.5px. **Third card is inverted**: `--ink-dark` bg, `--star-gold-dark` stars, `#E8EDF9` quote text. Keep existing review copy.

### 10. About (white)
Grid `1.1fr / .9fr`. Left: FIG 08 + H2 "Built by a local commuter who got tired of guessing." + existing story paragraph + mono line `INDEPENDENT · AD-FREE · NO ANALYTICS · NO THIRD-PARTY TRACKING`. Right: **SPECIFICATIONS table** (panel radius 8; ink header bar "SPECIFICATIONS"; 5 rows label/value with hairlines): `4.8 ★` App Store rating · `WISDOT` Official data source · `iOS 17.4+` iPhone · iPad · Mac · Vision · Watch · `1.2 MB` Lightweight & fast · `$0` Free forever. Labels Plex Mono 600 14px `--blue-primary`, min-width 90px.

### 11. Download CTA — Title Block (ink dark + light grid lines)
A 1.5px `rgba(255,255,255,.35)` bordered block (radius 8) split `1.4fr / 1fr`:
- Left cell: mono `TITLE BLOCK — SHEET 8 OF 8` + H2 "Ready to beat traffic?" (white, 44px) + copy + **white button** (ink text) with Apple logo "Download on the App Store"
- Right cell: 3 stacked mono field rows separated by the same border: PROJECT → TRAVEL TIMES MILWAUKEE · PRICE → $0 — FREE / SIZE → 1.2 MB · DATA → WISDOT / REV → 2.4 — 2026 (field labels 9.5px `--ondark-faint`, values white 11.5px)

### 12. Footer (white)
4 columns `1.6fr 1fr 1fr 1fr`: brand (TT tile + wordmark + one-liner + X link in mono `--blue-primary`) · PRODUCT links · LEGAL links · BUILT BY. Column headers: Plex Mono 10.5px letter-spacing 1.5px `--text-muted`, UPPERCASE. Links 13.5px `--text-nav`. Base bar (hairline top): mono 11px `© 2026 VINNY CARPENTER · MILWAUKEE MADE` / `DATA · WISCONSIN DOT`.

## Interactions & Behavior
- **Sticky nav** + smooth-scroll anchors (`#features`, `#live`, `#screens`, `#reviews`, `#about`), keep existing `scroll-padding-top`
- **Live board ticker** (adapt existing `script.js` demo-ticker): clock updates every 1s (`HH:MM:SS`); each tick has ~22% chance to nudge one random route ±1 min (floor 4 min). Freeze entirely under `prefers-reduced-motion: reduce`
- **Pulse animation** on the live dot: `@keyframes` opacity 1 → .35 → 1, 1.6s ease-in-out infinite; disable under reduced motion
- **Hovers** (design shows resting states; apply the site's existing transition timing ~150–250ms): solid buttons darken to `--ink-dark`-ward (e.g. #122A6B); dashed secondary button fills `--surface-tint`; nav/footer links → `--blue-primary`; feature cards raise border to `--blue-accent` (no shadow lift)
- **Focus states**: visible 2px outline in `--blue-accent`, offset 2px, on every interactive element (existing a11y commitment)
- Keep existing scroll-reveal (`data-reveal`) if desired — subtle fade/translate only; honor reduced motion

## Responsive behavior (lofi guidance)
- ≤1024px: hero and about/live-board/spotlight grids → single column, device imagery below copy; features 4→2 columns; reviews 3→1; footer 4→2
- ≤720px: H1 64→clamp to ~40px, H2 38→28px; features 2→1; screenshots become horizontal scroll-snap row (~72vw per shot); CTA title block stacks (fields row below); nav collapses to existing hamburger pattern; freeway strip chips wrap
- Grid-paper background and mono labels persist at all sizes; dashed callouts may drop their edge labels below 400px width

## State Management
Vanilla JS in `script.js`: nav-toggle open/closed (existing), live board `{clock, minutes[4]}` on a 1s interval, optional reveal-on-scroll IntersectionObserver (existing). No other state.

## Assets
All already in the repo under `/assets/`: `IMG_4571.png/webp` (hero, 6.1), `IMG_4572` (6.2), `IMG_4574` (6.3), `IMG_4576` (6.4), `IMG_4581` (6.5), `IMG_4584` (spotlight), `watch-main.png` (watch card), `tt-1024.png` (favicon/OG only — the nav now uses the typographic "TT" tile, not the icon image). Keep `<picture>` + webp sources and existing alt text. Apple logo + feature icons are inline SVGs (in the reference file and current index.html).

## Files
- `Landing — Blueprint.dc.html` — the approved hi-fi design reference (open in a browser; ignore the `<x-dc>`/`support.js` wrapper and the `{{ … }}` holes — those are prototype plumbing; all styles are inline on the elements)
- Target files in the repo: `index.html`, `styles.css`, `script.js`

## Checklist for the implementer
1. Swap font links to IBM Plex Sans/Mono; update `theme-color` to `#16337F`
2. Replace `:root` tokens in `styles.css`; add grid-paper backgrounds
3. Restyle nav → hero → strip → why → features → live board → spotlight (+watch card) → screenshots (5-up grid) → reviews → about (+spec table) → CTA title block → footer, per specs above
4. Adapt ticker JS; wire pulse + reduced-motion guards
5. Re-test: AA contrast, focus visibility, keyboard nav, mobile breakpoints, Lighthouse
