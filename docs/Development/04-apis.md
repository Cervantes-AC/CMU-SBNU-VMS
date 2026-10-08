# 04. APIs

## Folder purpose

Typed contracts between frontend, backend, and data services, including request/response models and error meanings. APIs must not expose arbitrary database access.

## Current status

No application API contract is implemented.

## Plan

1. Identify the operations required by the approved workflow.
2. Define typed inputs, outputs, bounds, and safe error responses.
3. Version or migrate contracts deliberately when they change.
4. Keep SDK-specific details behind repository/service boundaries in the Flutter client.

## Ready when

The client and trusted implementation agree on validated contract behavior, access checks, and error handling.
