# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Type
Static website landing page for Travel Times Milwaukee iOS app, deployed to AWS S3 with CloudFront.

## Development Commands
- **Deploy to AWS**: `./deploy.sh` - Deploys static files to S3 bucket and invalidates CloudFront cache
- **Local Development**: Open `index.html` directly in browser (no build process required)

## AWS Configuration
- **S3 Bucket**: `traveltimesapp.com`
- **CloudFront Distribution**: `E29CIMMJ1ZCXON`
- **Region**: `us-east-1`

## File Structure
- `index.html` - Main landing page with hero, features, screenshots, download, reviews, and about sections
- `styles.css` - CSS with Apple-inspired design system using CSS custom properties
- `script.js` - Interactive functionality including navigation, smooth scrolling, animations, and security-validated download handling
- `privacy.html` - Privacy policy page
- `terms.html` - Terms of use page
- `assets/` - Static assets including app screenshots and icons
- `deploy.sh` - AWS deployment script with error handling and cache control

## Security Implementation
- Comprehensive security headers (CSP, X-Frame-Options, X-XSS-Protection, etc.)
- Input validation for anchor links and download buttons
- Secure external link handling with `noopener` and `noreferrer`
- Content Security Policy restricts resource loading to trusted sources
- No sensitive data collection or third-party tracking

## Design System
"Warm Sunset Transit" theme with Mediterranean-inspired colors:

### Color Palette
- **Backgrounds**: Cream (#faf7f2), Sand (#f5efe6)
- **Primary accent**: Terracotta (#e07a5f)
- **CTA/Buttons**: Rust (#c45a3b)
- **Highlights**: Amber (#f4a261)
- **Success states**: Sage (#81b29a)
- **Text**: Deep Forest (#3d405b)

### Typography
- **Display/Headlines**: Fraunces (variable serif)
- **Body**: DM Sans (sans-serif)

### CSS Custom Properties
All colors, shadows, and spacing defined as CSS variables in `styles.css` for easy customization.

## Content Updates
When updating app information:
- App Store links: Search for `apps.apple.com` in `index.html`
- Hero stats: `.hero-stat` elements in `index.html`
- Screenshots: Replace PNG files in `assets/` directory
- Reviews: `.testimonial-card` elements in `index.html`
- Features: `.feature-card` elements in `index.html`