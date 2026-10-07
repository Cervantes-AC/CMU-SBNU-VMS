# TODO: QR duty monitoring

**Status:** QR Duty models, repository, controllers (scanner + monitor), and screens implemented. QR session creation with opaque tokens, scan validation with replay protection and capacity checks, and officer monitoring with paginated scan feed are complete. Camera permission UX and offline queue remain deferred per D-19. Follow the [AI coding workflow](../../../docs/ai-coding/workflow.md).

## Scope and authority

This feature would support event-bound duty/check-in QR flows. The canonical screen and file contract is in [Feature File Specifications](../../../docs/lib/features.md). QR policy is open under D-12; attendance and service-hour policy are open under D-10/D-25; offline behavior is open under D-19. Keep the feature disabled until owners approve token format, validation, expiry, replay handling, offline behavior, retention, and any attendance consequences.

## Required files and responsibilities

- [ ] `qr_duty_scanner_screen.dart`: request camera access only after an explanation; accept the documented opaque payload; show accepted, rejected, expired, unavailable/offline, and permission-denied outcomes; prevent duplicate camera callbacks.
- [ ] `qr_code_generator_screen.dart`: request creation/closure of a time-bound event session through a trusted endpoint; render an opaque QR without PII or signing secrets. No client-side token signing.
- [ ] `duty_monitoring_screen.dart`: display an authorized, paginated scan feed and distinguish a server-confirmed record from a pending local attempt.
- [ ] `qr_duty_controller.dart`: coordinate UI state, camera lifecycle, duplicate callback suppression, and repository intents; it must not validate trust, determine actor identity, award hours, or trust device time.
- [ ] `widgets/scan_permission_prompt.dart` only if a reusable, accessible permission explanation is required by the implementation.

## Prerequisites before implementation

- [ ] Product/security owners approve D-12 threat model, opaque token/session format, lifetime, event binding, signature/validation authority, replay/idempotency behavior, and failure response.
- [ ] Attendance owner closes D-10 and D-25 before QR results can affect attendance or official service hours.
- [ ] Product/security owners close D-19 before any offline queue or local sensitive-data persistence is designed.
- [ ] Trusted backend contract, rules, indexes, and emulator security tests are specified before client UI depends on them.
- [ ] Camera permission UX and supported device matrix are approved; no background camera/location behavior.

## Security requirements

- [ ] QR contents contain no PII, static credentials, signing secrets, or reusable bearer authority.
- [ ] Trusted backend validates session, event scope, current actor, expiry, status, duplicate/replay, and idempotency. Client clock and client assertions are never authoritative.
- [ ] A failed or offline scan is not presented as a recorded check-in. Retry cannot create a second attendance/duty record.
- [ ] Access to monitor/roster data is server-authorized and paginated; logs exclude QR payloads and personal details.

## Completion and verification

- [ ] All prerequisites are approved and recorded; feature route remains unavailable until then.
- [ ] Canonical scenarios include malformed, expired, replayed, cross-event, duplicate, denied-camera, denied-access, session-closed, and network-failure cases.
- [ ] Emulator/function security coverage proves the trusted authorization and replay behavior before release.
- [ ] These scenarios describe required future evidence and do not authorize adding or running tests. Follow [`AGENTS.md`](../../../AGENTS.md) and update this TODO, feature spec, decision register, and backlog together when the gate changes.
