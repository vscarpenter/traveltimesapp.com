# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Type
Static website landing page for Travel Times Milwaukee iOS app, deployed to AWS S3 with CloudFront. No build step — pure HTML/CSS/JS.

## Development Commands
- **Deploy to AWS**: `./deploy.sh` — syncs files to S3 and invalidates CloudFront
- **Local preview**: Open `index.html` directly in a browser, or serve the directory (e.g. `python3 -m http.server 8000`)

## AWS Configuration
- **S3 Bucket**: `traveltimesapp.com`
- **CloudFront Distribution**: `E29CIMMJ1ZCXON`
- **Region**: `us-east-1`

## Design System — "Blueprint"

The site uses a civil-engineering / DOT drawing-set aesthetic: grid-paper background, ink-navy headings, blueprint-blue dashed callouts, monospace `FIG. 0N —` labels, ■ status squares, and a download CTA styled as a drawing title block. Type is IBM Plex Sans (prose) + IBM Plex Mono (labels/data).

- **`DESIGN.md`** — the full design system: tokens, typography scale, motifs, component class map, motion, reuse rules. Read it before any visual work.
- **`PRODUCT.md`** — register (brand), audience, personality, anti-references, design principles.
- Tokens live in the `:root` block at the top of `styles.css` (single source of truth; DESIGN.md documents intent).
- **Do not "fix" token values back to the design handoff**: `--text-muted`, `--status-green`, `--status-amber` were deliberately darkened from the handoff to meet WCAG AA at label sizes (drift table in DESIGN.md).
- Original handoff reference: `design_handoff_blueprint_landing/` (prototype HTML + spec README).

## File Structure
- `index.html` — Landing page. Section order (bands alternate paper/white, see DESIGN.md):
  hero `#top` → freeway strip → why → features `#features` → live board `#live` → spotlight `#platform` → screenshots `#screenshots` → reviews `#reviews` → about `#about` → CTA title block `#download` → footer
- `styles.css` — tokens → reset/base → blueprint motifs → components → responsive
- `script.js` — Vanilla JS, progressive (page works without JS): footer year, mobile nav toggle, scroll reveal (`[data-reveal]` + IntersectionObserver), live-board ticker (`[data-clock]`/`[data-eta]`), external-link `rel` hardening
- `privacy.html` — Privacy policy (self-contained, uses Tailwind CDN)
- `terms.html` — Terms of use (self-contained, uses Tailwind CDN)
- `404.html` — Not-found page (Blueprint-styled, uses styles.css; served with a real 404 via CloudFront custom error response)
- `assets/` — App screenshots (`IMG_*.png/.webp`, `watch-*.png/.webp`), icons (`tt-1024.png`), `og-image.png`
- `deploy.sh` — AWS sync + CloudFront invalidation

### Live board (`#live`)
Demo panel, not real data (footer strip says so). Clock ticks every 1s; each tick has ~22% chance to nudge one `[data-eta]` value ±1 min (floor 4). Entirely frozen under `prefers-reduced-motion`. Route rows are static HTML in `.board-row`s.

### Spotlight (`#platform`)
Live Activities story: dashed callout framing `IMG_4584.png` (real Lock Screen) + checklist, with the Apple Watch card (`.watch-card`, `watch-main.png`) below. Rule of thumb: when real screenshots exist, prefer them over CSS-composed mockups.

## Security Implementation
- Security headers set at CloudFront (CSP, X-Frame-Options, X-XSS-Protection)
- External links hardened with `rel="noopener noreferrer"` + verified by script.js at runtime
- No third-party tracking, no analytics, no cookies
- Font loading limited to Google Fonts

## Content Updates

When updating app information:
- **App Store URL**: search for `itunes.apple.com` in `index.html` (header CTA, hero CTA, final CTA, footer)
- **Hero trust row**: `.trust-row` in `index.html` (rating · free/no ads · no tracking)
- **Feature cards**: `.feature-card` items in `.feature-grid` (currently 8 cards, 4×2 desktop, mono indices `3.1`–`3.8`)
- **Live board routes**: `.board-row` entries — segment, span, ■ status, `[data-eta]` minutes
- **Screenshots**: replace files in `assets/` (`IMG_*.png` + matching `.webp`); update `<figure class="shot">` entries in `.screens-grid` (5-up grid, indices `6.1`–`6.5`)
- **Reviews**: `.review-card` items in `.review-grid` (third card uses `--dark` variant, indices `REPORT 7.n`)
- **Tracked freeways**: `.chip` spans in `.strip`
- **Spec table**: `.spec-row` label/value pairs in `#about`
- **CTA title-block fields**: `.cta-fields` (PROJECT / PRICE / SIZE / DATA / REV — bump REV on meaningful releases)
- **Structured data `featureList`**: JSON-LD block in `<head>` — keep in sync with actual feature grid
- Numbered indices follow their section's FIG number — renumber if sections are added/reordered (see DESIGN.md motif 5)

### Image assets
- Each screenshot needs a `.png` **and** `.webp` pair; the `<picture>` source handles negotiation.
- Generate `.webp` from `.png`: `cwebp -q 82 -mt "IMG_X.png" -o "IMG_X.webp"` (~80–90% smaller).
- **For oversized iOS screenshot PNGs** (e.g. 8 MB originals), shrink the fallback without losing visible quality:
  `magick IMG_X.png -resize 50% -strip -colors 256 -dither FloydSteinberg PNG8:IMG_X.png`
  Yields ~200–300 KB. Modern browsers get the full-res WebP anyway; PNG is just the fallback.
- iPhone Pro screenshot ratio: 1320×2868 → display as `width="300" height="652"`.
- Apple Watch screenshot ratio: 422×514 → display as `width="170" height="207"` inside `.watch-frame`.

## Conventions
- Semantic HTML first (`<main>`, `<section>`, `<nav>`, `<figure>`)
- SVG icons inline, `stroke-width="2"`, `currentColor` (renders `--blue-accent` in icon tiles) — no icon fonts, no emojis as icons
- Minimum 44×44 touch targets (enforced via `@media (pointer: coarse)`)
- Focus-visible outlines on all interactive elements (2px `--blue-accent`)
- Every image has `alt` text (empty `alt=""` only for purely decorative)
- Responsive breakpoints (desktop-first): ≤1024 (story grids collapse, features 4→2, reviews 3→1, footer 4→2), ≤720 (hamburger nav, fluid headings, features→1, screenshots→scroll-snap row), ≤400 (callout labels drop)
- All motion disabled/frozen under `prefers-reduced-motion: reduce`
- Anchors preserved: `#features`, `#live`, `#platform`, `#screenshots`, `#reviews`, `#download`, `#about` (privacy.html and terms.html link back to these)
