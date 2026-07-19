# Authentication, MFA & RBAC

## 6.1 Authentication & Authorization

Authentication is powered by Firebase Auth with email/password credentials. The system implements a registration-approval workflow where new accounts start in "pending" status and require admin approval before gaining access.

### Capabilities

- Email/password sign-in with session persistence (LOCAL or SESSION)
- Registration with role selection and admin approval workflow
- Password reset via Firebase email with rate limiting (3 attempts per 15 minutes)
- Account lockout after 5 failed login attempts (15-minute lock duration)
- Re-authentication required for sensitive operations
- Organization account creation via Firebase Auth REST API (no session switching)
- Admin impersonation for support and debugging (logged in audit trail)
- Force logout and session termination

---

## 6.2 Multi-Factor Authentication (MFA)

Optional MFA adds an extra layer of security. When enabled, users must verify a 6-digit OTP code after primary authentication before accessing protected features.

### Mechanisms

- **OTP Codes** — 6-digit verification codes stored in Firestore with 10-minute expiry
- **Backup Codes** — 8 single-use codes, SHA-256 hashed on the user document for recovery
- **Inline Verification** — MFA challenge is presented inline via RouteGuard before rendering content
- **Rate Limiting** — Maximum 3 MFA attempts per 5-minute window

---

## 6.3 Role-Based Access Control (RBAC)

Access control is enforced at three levels: client-side (RouteGuard widget), server-side (Firestore security rules), and application-level (service/repository layer).

### Hierarchy

- **Admin (Level 3)** — Full access to all features, user management, system configuration
- **Officer (Level 2)** — Event management, attendance, incident review, announcements
- **Member (Level 1)** — Event participation, incident reporting, profile management
- **Organization (Level 1)** — Group-level participation with member oversight

The hasAccess() method enforces hierarchical access where higher roles inherit lower role permissions. Feature-based granularity is managed through a Feature enum with 20 distinct permission values mapped per role.
