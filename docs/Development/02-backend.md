# 02. Backend

## Folder purpose

Trusted server-side workflows that require privileged validation or mutation.

## Current status

No backend functions or server application are configured in this repository.

## Plan

1. Decide whether trusted functions are needed for the first workflow and identify their owner and runtime.
2. Specify each operation's inputs, authorization checks, validation, audit requirements, and failure behavior.
3. Implement only approved, narrow operations. Do not create a generic database access endpoint.
4. Keep privileged keys and administrative SDK access on trusted infrastructure.

## Ready when

Every operation has a defined caller, authorization policy, bounded effect, and local test strategy.
