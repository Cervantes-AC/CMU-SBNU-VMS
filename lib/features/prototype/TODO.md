# Member Workspace Frontend Prototype

**Status:** interactive UI prototype; synthetic content only; no backend services are connected.

## Implemented

- Responsive member workspace shell with desktop sidebar and compact bottom navigation.
- Overview with sample summary cards, next-event card, and announcement previews.
- Events list with local search, category filters, and a local-only join toggle.
- Personal attendance history with illustrative records and an explicit sample-data notice.
- Announcements list with sample unit updates.
- Profile overview with fictional identity fields and a disabled-by-contract local edit notice.
- Persistent demo indicator and no-op boundaries for actions that require a service.

## Prototype constraints

- All displayed names, IDs, dates, service hours, events, and announcements are fabricated examples.
- Search, navigation, filters, and the joined-event state exist only in memory and reset when the app restarts.
- No authentication, account approval, authorization, Firebase, network calls, persistence, or real member records are used.
- The visible institutional logo assets remain subject to D-18 approval before public use.
- Do not describe this frontend as a functioning volunteer service or use it for unit operations.

## Next frontend work

- Get product-owner review of the member dashboard content hierarchy and screen labels.
- Implement approved sign-in, reset-password, pending-access, and access-denied presentation states after auth UX requirements are confirmed. Keep the UI disconnected from auth until the secure auth/session work is separately authorized and designed.
- Add event detail presentation and empty/loading/error/offline states based on approved UI contracts.
- Implement role-specific officer/admin shells only after the role matrix and intended tasks are accepted.
- Update widget tests and accessibility/responsive review when implementation verification is requested.

## Acceptance boundary

The prototype is ready for visual discussion only. It is not a completed P0 feature, production-ready app shell, or release candidate. See the product requirements, route contract, and decision register before adding user data, service actions, institutional claims, or network behavior.
