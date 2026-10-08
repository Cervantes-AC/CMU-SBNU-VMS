# 07. Testing

## Folder purpose

Unit, widget, integration, and security checks using synthetic data or local emulators.

## Current status

`test/widget_test.dart` exists but is documented as stale relative to the current starter screen.

## Plan

1. Agree on test coverage and update the starter smoke test when verification is authorized.
2. Add unit tests for domain rules and validation as those parts are implemented.
3. Add widget tests for user-visible states and interactions.
4. Add emulator integration and database-rule tests before protected data access is enabled.
5. Never use production member or incident data as test fixtures.

## Ready when

Each implemented workflow has checks for core success and denial/error paths, with required local test commands documented.
