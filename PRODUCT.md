# Product

## Register

brand

## Users

Milwaukee-area freeway commuters evaluating a free iOS traffic app. They arrive from the App Store listing, a social link, or word of mouth, usually on a phone, often mid-commute-planning. Their job: decide in under a minute whether Travel Times is trustworthy and worth installing. Secondary audience: existing users looking for the privacy policy, terms, or what's new.

## Product Purpose

traveltimesapp.com is the marketing landing page for Travel Times Milwaukee, a free, ad-free iOS app showing real-time WisDOT travel times for Milwaukee freeways. The page exists to drive App Store downloads. Success = a visitor understands the app's value (official data, zero clutter, free forever) and taps Download.

## Brand Personality

Precise, civic, understated. The site presents itself as a civil-engineering drawing set — an official DOT document, not an ad. Three words: **engineered, local, trustworthy**. The emotional goal is quiet confidence: the page should feel like it was drafted by the same discipline that builds the freeways it monitors.

## Anti-references

- The site's own previous design ("Indigo Transit": violet gradients, serif hero, cream backgrounds) — retired because it read as a generic SaaS template.
- Gradient-mesh / glassmorphism startup landing pages; hero-metric blocks with gradient accents.
- Colored status **pills** or traffic-light dots — status is always a mono ■ square with an uppercase label.
- Marketing-speak ("seamless", "supercharge"). The copy persuades with specifics: $0, 1.2 MB, iOS 17.4+, WisDOT.

## Design Principles

1. **The document is the brand.** Every element should read as part of a drawing set: figures, sheets, details, title block. Decoration that couldn't appear on a blueprint doesn't belong.
2. **Specifics do the persuading.** Real screenshots, real ratings, named data sources, exact sizes. Demo data is labeled DEMO DATA.
3. **Nothing you don't.** The app's promise applies to the page: one idea per section, no filler.
4. **Borders, not shadows.** Structure comes from hairlines and frames; elevation is reserved for device imagery and the live board.
5. **Accessibility outranks fidelity.** When a handoff color fails WCAG AA, the token gets darkened and the change documented (see DESIGN.md drift table).

## Accessibility & Inclusion

WCAG 2.1 AA contrast on all text (tokens pre-corrected for small mono labels). Visible focus (2px `--blue-accent` outline), skip link, semantic landmarks, alt text on every image, 44×44 touch targets on coarse pointers, full `prefers-reduced-motion` fallbacks (ticker freezes, pulse and reveals disabled). Status colors are never the only signal — every status square carries a text label.
