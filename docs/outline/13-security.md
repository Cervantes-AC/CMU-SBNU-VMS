# Security Architecture

## Authentication Security

- Firebase Auth with email/password credentials
- Session persistence options: LOCAL (remember me) or SESSION
- Account lockout: 5 failed attempts → 15-minute lock
- Password policy: min 8 chars, uppercase, lowercase, number, special character
- Re-authentication required for sensitive operations
- Rate limiting: login (5/min), MFA (3/5min), password reset (3/15min)

## Data Security

- Client-side input sanitization via `InputSanitizer.sanitize()` strips HTML tags, script content, `javascript:` protocols, and event handlers
- Server-side anti-XSS via `isSafeText()` and `isSafeShortText()` in Firestore rules
- XOR obfuscation for API keys stored in SharedPreferences
- SHA-256 hashing for MFA backup codes
- SHA-1 signed requests for Cloudinary uploads

## Access Control

- Three-tier enforcement: client-side (RouteGuard), server-side (Firestore rules), application-level (service layer)
- Self-update protection: users cannot change their own role or status
- Admin impersonation logged in immutable audit trail
- Session management with 30-minute timeout and activity monitoring

## Infrastructure Security

- CORS headers via Cloud Functions
- Content Security Policy (CSP) headers
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- XSS Protection header
- HTTP Strict Transport Security (HSTS)
- Permissions-Policy restrictions
