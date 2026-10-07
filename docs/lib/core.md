# Core Infrastructure File Specifications

Core code is framework-adjacent infrastructure shared across features. Keep pure logic free of Firebase and Flutter where possible.

## Constants and configuration

### `lib/core/constants/app_constants.dart`

Expose immutable product-independent limits and configuration keys only: supported page size, text/input limits, environment key names, cache schema version, unit timezone identifier after it is confirmed, and app metadata. Do not store API keys, passwords, real phone numbers, role policies, or mutable feature state here. Constants requiring product approval must be annotated with the decision/source.

### `lib/core/constants/route_names.dart`

Expose typed or constant route path/name definitions for public routes and feature routes. Keep route authorization metadata in one shared route table used by the router and `RouteGuard`; no screen should invent route strings. Tests ensure no duplicate path/name and every protected route has access metadata.

### `lib/core/constants/firestore_paths.dart`

Expose typed path builders for only approved collections and nested paths (for example `users/{uid}` and device-token paths). Validate path segments and never accept a raw user-provided collection name. Names must match `firestore.rules`, indexes and the data dictionary. Tests verify expected paths and reject invalid IDs.

## Error handling

### `lib/core/error/app_exception.dart`

Define a sealed `AppException` family with stable codes/categories for validation, unauthenticated, permission denied, not found, conflict, unavailable/offline, rate limit, and unexpected failures. Keep technical cause privately for redacted diagnostics; user-facing text must be produced by the mapper. Do not retain request payloads in exception objects.

### `lib/core/error/error_mapper.dart`

Map Firebase/platform exceptions and domain failures into `AppException`; preserve cancellation separately from failure. Avoid relying only on message substring matching. Include correlation ID if available, but never personal data. Unit-test known SDK codes and unknown/future codes.

## Theme

### `lib/core/theme/app_theme.dart`

Expose `AppTheme.light` and `AppTheme.dark` (and only approved theme variants) built from central semantic color, typography and spacing tokens. Respect contrast, text scaling, focus states, reduced motion and responsive widths. Use institution logos/colors only after branding approval. No screen-level hard-coded palette for status semantics.

### `lib/core/theme/theme_provider.dart`

Expose `ThemeProvider` with current `ThemeMode`, `load()`, and `setThemeMode()`. Persist only the preference, not personal data; loading must have deterministic default and safe failure behavior. Avoid writing during build. Tests cover defaults, persistence, invalid stored value and notifications.

## Cache and connectivity

### `lib/core/cache/cache_keys.dart`

Define stable, namespaced cache keys and versioning. User-specific keys include UID and schema version. Classify sensitive caches and define TTL in the consuming repository; never use arbitrary Firestore paths as cache keys.

### `lib/core/cache/cache_service.dart`

Define `CacheService` contract/implementation for initialize, typed get/set, remove, clear namespace and clear user scope. If using Hive, register adapters centrally and handle corrupt/stale records. Expose cache metadata (stored-at/version) so repositories can mark stale data. Clear authenticated scope on sign-out/account disable. Tests: TTL expiry, version mismatch, serialization failure, user isolation, clear and offline read.

### `lib/core/connectivity/connectivity_service.dart`

Expose `ConnectivityService` stream/current status with `dispose()`. Report network-interface status as a hint only; a request still handles backend unavailability. Debounce noisy transitions and do not claim online just because Wi-Fi is connected. Test stream transitions and disposal with an injected platform adapter.

## Sync (conditional)

### `lib/core/sync/sync_service.dart`

Implement only for specifically approved offline mutations. Expose queue status and `syncPending()`; queue items have operation type, user UID, entity key, idempotency key, creation time and retry metadata. Re-check current user before syncing, stop on permission revocation/sign-out, use exponential backoff with jitter, cap retries, surface conflicts for review, and never sync a stale user's writes under another account. No generic arbitrary Firestore operation queue. Tests cover duplicate delivery, conflict, sign-out, revoked access, ordering, retry cap and app restart.

## Pure/shared utilities

### `lib/core/utils/validators.dart`

Expose pure validators for required text, length, email format, phone display/input, safe free text, and approved identifiers. Client validation improves UX but duplicates authoritative backend checks. Return structured validation errors and do not normalize away meaningful user content. Test boundary lengths, whitespace, Unicode, malformed input and markup/control characters.

### `lib/core/utils/date_helpers.dart`

Expose parsers/formatters and explicit conversion helpers. Keep storage UTC; require a timezone argument for unit-local date-range boundaries. Define inclusive/exclusive interval behavior. Test daylight-saving transitions where relevant, midnight boundaries, invalid input and UTC/local conversions.

### `lib/core/utils/service_hours_calculator.dart`

Pure deterministic calculation from approved attendance/duty facts to hours; define rounding, minimum/maximum duration, timezone, overnight event and correction behavior in a documented policy. Never accept a user-maintained total as source of truth. Test negative/zero, overlaps, duplicate records, rounding and boundary timestamps.

### `lib/core/utils/responsive.dart`

Expose app breakpoints and layout helpers, not device identity. Use `LayoutBuilder` constraints; support compact phone, tablet and wide web layouts. Tests cover just-below/at/above each breakpoint and large text scaling.

### `lib/core/utils/logger.dart`

Expose structured log levels and a redaction boundary. Never log user-entered text, email, phone, location, auth tokens, FCM tokens, document payloads or exception causes containing data. Include operation name and safe correlation ID. Tests prove configured sensitive keys/values are redacted.

