# Navigation, Screen Flows, and UI Contract

**Status:** proposed functional design baseline; institutional visual identity remains subject to D-18. Use Flutter Material 3 semantic components as the temporary default; use a neutral accessible palette and text/placeholder mark until branding is approved.

## 1. Global flow

```text
App start → configuration/bootstrap state → auth state
  signed out → public landing (if enabled) / sign in
  signed in → load profile → status gate
    pending → pending-access screen + sign out
    denied/blocked/suspended/deactivated/missing → access denied + sign out/contact
    approved → role-based dashboard and allowed navigation
```

Auth/profile stream is the sole client routing input. Route guard does not fetch Firestore inside `redirect`/build. On sign-out, account change or status/role update, remove protected route state and user-scoped caches.

## 2. Route table (proposed paths)

| Route | Screen | Access | Notes |
|---|---|---|---|
| `/` | `LandingPage` | public if D-17 permits; otherwise redirect to sign-in | Public content only, no records |
| `/sign-in` | `AuthScreen` | signed out | Password reset entry; no public role selector |
| `/access/pending` | `PendingAccessScreen` | authenticated pending | Sign-out and support instruction |
| `/access/denied` | `AccessDeniedScreen` | denied/missing/blocked/suspended/deactivated/malformed profile | Generic safe copy, sign-out |
| `/member/home` | `MemberDashboard` | approved member | Own summary + published items |
| `/officer/home` | `OfficerDashboard` | approved officer | Scoped operational summary |
| `/admin/home` | `AdminDashboard` | approved admin | Minimum necessary admin summary |
| `/profile` | `ProfileScreen` | approved roles | Own profile only |
| `/events` | `EventsScreen` | approved roles | Published list; staff controls role-gated |
| `/events/:eventId` | `EventDetailScreen` | approved roles | Authorized event projection |
| `/attendance` | `AttendanceScreen` | officer/admin | Event roster and corrections |
| `/my-attendance` | `MemberAttendanceScreen` | member/officer/admin own view | Own records; staff role may access own records too |
| `/announcements` | `AnnouncementsScreen` | approved roles | Published list; staff authoring controls |
| `/admin/users` | `UserManagementScreen` | admin | Trusted review workflows |
| `/admin/audit` | `AuditLogsScreen` | admin | Read-only, paginated |
| `/settings` | `SettingsScreen` | authenticated | Only implemented preferences and security controls |
| `/help` | `UserGuideScreen` | public/approved subset | Content filtered by role |

Routes for incidents, QR duty, reports, analytics, backup, import/export, database management, admin queries and PDF are not registered until their feature decision gates close. Unknown/deep links resolve to a safe not-found page; they do not reveal whether records exist.

## 3. Navigation destinations

- Member: Home, Events, My Attendance, Announcements, Profile, Help, Settings.
- Officer: Home, Events, Attendance, Announcements, Reports only if approved, Profile, Help, Settings.
- Admin: Home, Events, Attendance, Announcements, User Management, Audit Logs, Analytics only if approved, Profile, Help, Settings.
- Compact widths use bottom navigation for a small primary set and an overflow/drawer for secondary items. Tablet/wide layouts use navigation rail/drawer. Current route has visible and semantic selected state.

Every destination comes from one typed route catalog with access metadata. UI filtering and route guard use that catalog; backend still enforces each record operation.

## 4. Screen-level behavior

### Sign-in

Email and password fields, submit, reset-password action, pending/verification help, visible loading state, inline field validation, generic safe auth error. Autofill and keyboard submit supported. Registration is hidden until D-07 approves it. Never show role selection.

### Dashboard

Each card links to a defined route and loads from a bounded role-authorized repository query. Skeleton/loading, empty, stale/offline and retryable error states are distinct. No invented chart/stat fields. Charts wait until an approved metric dictionary exists.

### Events

List with title, date/time in unit timezone, venue, lifecycle badge, audience-safe summary and paging. Event detail contains only fields viewer can access. Officer create/edit uses validated form and confirmation for cancellation; members can request participation only if enabled.

### Attendance

Officer selects a manageable event; roster rows show only approved member projection and current status. Save status as an idempotent action. Corrections require reason and confirmation. Member view is read-only. No hand-editable hour total.

### Management screens

Account review details are minimized. Role/status changes show exact effect, require confirmation and trusted operation; dangerous operations require fresh authentication if implemented. Audit viewer is read-only and redacts summaries.

## 5. Visual and interaction defaults

- Material 3, light/dark system theme, 8-point spacing rhythm, responsive maximum content width and visible focus ring.
- Typography uses theme text styles and respects system scaling; do not set fixed heights around multi-line text.
- Status is represented with text and an optional icon plus color; color is not the only cue.
- Forms have labels, helper/error text, input bounds, keyboard type, focus order and submit disabled while in flight.
- Destructive actions require a dialog naming the action and affected object; cancel is safe default.
- All async screens model loading/empty/error/stale/offline/success. Feedback does not expose raw service errors.
- Use CMU/SBNU logo assets only after D-18 acceptance; current root PNGs are not automatically approved for publication.

## 6. UI decisions requiring closure

D-17 decides public landing and platform targets; D-18 decides brand assets; D-21 decides browser/device/language/accessibility matrix. Proposed layout above is enough for local implementation but owner must review user-facing copy and final styling before release.

