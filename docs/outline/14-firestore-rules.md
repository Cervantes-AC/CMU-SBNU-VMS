# Firestore Security Rules

The `firestore.rules` file (314 lines) implements a comprehensive deny-by-default security model with role-based access control for every collection.

## Helper Functions

- `isSignedIn()` — Verifies the user is authenticated
- `isOwner(uid)` — Checks if the authenticated user matches the given UID
- `getRole()` — Retrieves the user's role from their Firestore document
- `isOfficerOrAdmin()` — Checks if the user has officer or admin role
- `isSuperAdmin()` — Checks for admin role specifically
- `isApprovedStaff()` — Verifies approved status with officer or admin role

## Collection-Level Rules

- **users** — Read: signed in; Create: self/org; Update: self (limited fields) or admin; Delete: admin only
- **events** — Read: signed in; Create/Update: officer+; Delete: admin only
- **incidents** — Read: signed in; Create: signed in; Update: officer+ (status changes); Delete: admin
- **announcements** — Read: signed in; Write: officer+
- **attendance** — Read: signed in; Write: officer+
- **auditLogs** — Read: officer+; Create: signed in; No update/delete (append-only)
- **qrDutyRecords** — Read: signed in; Create: self only (deterministic ID); Update: admin
- **backupRecords** — Admin only
- **mfaCodes** — Own codes only; No update/delete
- **userSessions** — Own sessions; Delete: admin
- **contactInquiries** — Create: public (validated); Read: officer+
