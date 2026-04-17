# Travel Times Milwaukee — Landing Page

Static landing page for the [Travel Times Milwaukee](https://itunes.apple.com/us/app/apple-store/id932688030) iOS app. Hosted on AWS S3 + CloudFront at [traveltimesapp.com](https://traveltimesapp.com).

## Stack

No build step. Vanilla HTML, CSS, and JavaScript.

- `index.html` — landing page markup
- `styles.css` — design tokens + components (Outfit / Work Sans / JetBrains Mono)
- `script.js` — nav toggle, scroll reveals, screenshot carousel, live-demo ticker
- `privacy.html`, `terms.html` — standalone legal pages (Tailwind CDN)
- `assets/` — app screenshots, icons, OG image
- `deploy.sh` — S3 sync + CloudFront invalidation

## Local preview

```bash
# Just open the file
open index.html

# Or serve it (better for testing lazy-loaded assets)
python3 -m http.server 8000
```

## Deploy

```bash
./deploy.sh
```

Requires AWS CLI configured for the `traveltimesapp.com` bucket and CloudFront distribution `E29CIMMJ1ZCXON`.

## Design

Indigo-primary palette that matches the in-app theme, with warm amber for CTAs and green/yellow/red traffic semantics. Full palette and token reference in [`CLAUDE.md`](./CLAUDE.md).

Accessibility commitments:
- WCAG AA text contrast (≥ 4.5:1)
- 44×44 minimum touch targets
- Visible focus states on every interactive element
- `prefers-reduced-motion: reduce` honored across the page
- Semantic landmarks, alt text, and keyboard-navigable carousel

## App info

| | |
|---|---|
| Platform | iOS 17.4+ (iPhone · iPad · Mac · Vision) |
| Size | ~1.2 MB |
| Price | Free |
| Data | Wisconsin DOT real-time feeds |
| Developer | [Vinny Carpenter](https://vinny.dev) |

## License

© Vinny Carpenter. The landing page source in this repository is proprietary and not licensed for reuse.
