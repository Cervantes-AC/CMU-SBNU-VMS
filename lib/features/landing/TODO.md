# Landing Feature Status and TODO

**Status:** The local app starts at the landing page (`/`). The page provides a direct path to member sign-in (`/sign-in`) and uses the CMU and SBNU logo files from `assets/images/`. Authentication is not connected; the sign-in page currently explains that limitation and disables submission.

## Implemented

- Responsive landing content for narrow and wide layouts.
- Accessible, contained display of the two configured logo assets.
- Member sign-in actions in the header, access notice, and hero section; all navigate to `/sign-in`.
- Product areas described without sample member identities, records, metrics, or fake service results.
- Local-only disclosure that member services are not connected.
- Root route `/` starts at this page; `/sign-in` and `/password-reset` remain separate routes.

## Remaining work

- [ ] Product owner reviews the copy, navigation, and described service areas.
- [ ] Record D-17 approval before public hosting or enabling an external public landing route.
- [ ] Record D-18 brand approval before publishing CMU/SBNU names and logos.
- [ ] Confirm platform and accessibility scope under D-21.
- [ ] Replace the disabled sign-in service action only when the approved auth controller/repository are connected.
- [ ] Update the widget smoke test, which still expects the previous landing preview content, when test changes are authorized.

## Boundary

This landing page is the local application entry, not proof that member services or public hosting are ready. It loads no Firebase or member data, offers no registration/contact form, and must not be published while the required approval decisions remain open.
