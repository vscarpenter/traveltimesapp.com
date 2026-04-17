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

## File Structure
- `index.html` — Landing page (hero → freeway strip → why → features → live demo → **platform spotlight** → screenshots → reviews → about → CTA → footer)
- `styles.css` — Design system + components
- `script.js` — Vanilla JS: nav toggle, scroll reveals, carousel, live-demo ticker
- `privacy.html` — Privacy policy (self-contained, uses Tailwind CDN)
- `terms.html` — Terms of use (self-contained, uses Tailwind CDN)
- `assets/` — App screenshots (`IMG_*.png/.webp`, `watch-*.png/.webp`), icons (`tt-1024.png`), `og-image.png`
- `deploy.sh` — AWS sync + CloudFront invalidation

### Hero section
Dark indigo hero (`linear-gradient(160deg, #15122e → #28204b)` + violet/indigo radial glows). Three-device composition:
- Center: iPhone (`.phone-hero`) with `IMG_4571` screenshot, upright, z-index 2
- Upper-left: tilted Apple Watch (`.watch-hero-left`, `watch-scrolled.png`) rotated `-14deg`, scaled `.62`
- Lower-right: tilted Apple Watch (`.watch-hero-right`, `watch-main.png`) rotated `+9deg`, scaled `.62`

Both watches use `filter: drop-shadow` for depth, `pointer-events: none`, and `aria-hidden="true"` — the centered iPhone carries the semantic labeling. The hero has a `::after` fade at the bottom that softens the transition into the light freeway strip.

Buttons on dark bg: `.btn-inverse` (white) for primary, `.btn-ghost-dark` (transparent + white border) for secondary.

### Platform Spotlight section (`#platform`)
Single card (`.spotlight-solo`) focused on Live Activities only — the Apple Watch story is now told in the hero. Uses `IMG_4584.png` (real Lock Screen) inside `.live-phone` dark frame with `.spotlight-card` structure (visual left, body right). Rule of thumb: when real screenshots exist, prefer them over CSS-composed mockups.

### About section
`.about-badges` grid uses `.badge-featured` as a full-width gradient card at the top (grid-column: 1 / -1) showing the 4.8 rating with stars. The remaining four badges (WisDOT / iOS 17.4+ / 1.2 MB / $0) fill the 2×2 below. Hero stats moved here in the dark-hero redesign — don't put them back in the hero.

## Design System

"Indigo Transit" — matches the in-app lavender/purple theme with warm accents for CTAs.

### Palette
- **Primary (indigo-600)**: `#4f46e5` — headlines accent, nav active, primary buttons
- **Primary dark (indigo-700)**: `#4338ca` — hover states, dark band
- **Accent (violet-400)**: `#a78bfa` — hero gradient, featured cards
- **CTA contrast (amber-500)**: `#f59e0b` — star ratings, delay alerts, inverse button hover
- **Traffic semantics**: green `#22c55e`, yellow `#eab308`, red `#ef4444`
- **Backgrounds**: cream `#fafaf7`, lavender-50 `#f5f3ff`, paper `#ffffff`
- **Text**: slate-900 `#0f172a` (primary), slate-600 `#475569` (muted)

All tokens defined as CSS custom properties at the top of `styles.css`.

### Typography
- **Hero headline (Playfair Display)**: the serif "Never miss your route" — editorial weight, 700/800 only
- **Display (Outfit)**: h2/h3 elsewhere, buttons, stat figures — geometric, modern
- **Body (Work Sans)**: paragraphs, UI text
- **Mono (JetBrains Mono)**: route codes (I-94 EB), clock
- Loaded from Google Fonts via `<link>` preconnect + single combined stylesheet URL

### Motion
- Easing: `cubic-bezier(.4, 0, .2, 1)` (base), `cubic-bezier(.2, .8, .2, 1)` (out)
- Durations: 150ms (fast), 250ms (base), 400ms (slow)
- All animation disabled under `prefers-reduced-motion: reduce`

## Security Implementation
- Security headers set at CloudFront (CSP, X-Frame-Options, X-XSS-Protection)
- External links hardened with `rel="noopener noreferrer"` + verified by script.js at runtime
- No third-party tracking, no analytics, no cookies
- Font loading limited to Google Fonts

## Content Updates

When updating app information:
- **App Store URL**: search for `itunes.apple.com` in `index.html` (appears in header CTA, hero CTA, final CTA, footer)
- **Hero stats**: `.hero-stats` block in `index.html`
- **Feature cards**: `.feature-grid` items in `index.html` (currently 9 cards, 3×3 desktop)
- **Hero "New" callout**: `.hero-new` link in `index.html` — jumps to `#platform`
- **Platform Spotlight cards**: `<article class="spotlight-card">` blocks inside `<section id="platform">` — replace image references to swap watch / Live Activity screenshots
- **Screenshots**: replace files in `assets/` (`IMG_*.png` and generate matching `.webp`); update `<figure class="shot">` entries in the carousel
- **Reviews**: `.review-grid` items in `index.html`
- **Tracked freeways**: `.strip-list` in `index.html`
- **Structured data `featureList`**: JSON-LD block in `<head>` — keep in sync with actual feature grid

### Image assets
- Each screenshot needs a `.png` **and** `.webp` pair; the `<picture>` source handles negotiation.
- Generate `.webp` from `.png`: `cwebp -q 82 -mt "IMG_X.png" -o "IMG_X.webp"` (~80–90% smaller).
- **For oversized iOS screenshot PNGs** (e.g. 8 MB originals), shrink the fallback without losing visible quality:
  `magick IMG_X.png -resize 50% -strip -colors 256 -dither FloydSteinberg PNG8:IMG_X.png`
  Yields ~200–300 KB. Modern browsers get the full-res WebP anyway; PNG is just the fallback.
- iPhone Pro screenshot ratio: 1320×2868 → display as `width="300" height="652"`.
- Apple Watch screenshot ratio: 422×514 → display as `width="170" height="207"` inside `.watch-body`.

## Conventions
- Semantic HTML first (`<main>`, `<section>`, `<nav>`, `<figure>`)
- SVG icons inline — no icon fonts, no emojis as icons
- Minimum 44×44 touch targets on all interactive elements
- Focus-visible outlines on all interactive elements
- Every image has `alt` text (empty `alt=""` only for purely decorative)
- Responsive breakpoints: 560, 740, 960 (mobile-first) — 740 collapses spotlight-card to stacked, 960 collapses hero/demo/about grids
- Anchors preserved: `#features`, `#platform`, `#screenshots`, `#reviews`, `#download`, `#about` (privacy.html and terms.html link back to these; hero + footer also link to `#platform`)
