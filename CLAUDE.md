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
Uses Apple-inspired color palette defined in CSS custom properties:
- Primary colors: `--primary-color` (#007aff), `--secondary-color` (#ff6b35)
- Text hierarchy: `--text-primary`, `--text-secondary`, `--text-tertiary`
- Gradients and shadows following Apple's design language

## Content Updates
When updating app information:
- App Store link: Lines 74, 200 in `index.html`
- App stats: Lines 60-72 in `index.html` 
- Screenshots: Replace files in `assets/` directory
- Reviews: Lines 232-249 in `index.html`