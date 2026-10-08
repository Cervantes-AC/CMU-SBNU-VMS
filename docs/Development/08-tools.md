# 08. Tools

## Folder purpose

Small developer utilities, scripts, and configuration that support repeatable local work.

## Current status

Flutter tooling and project configuration are present; no application-specific tool suite is established.

## Plan

1. Add a tool only for a repeated, clearly defined development task.
2. Document prerequisites, inputs, outputs, and safe execution scope.
3. Keep tools idempotent where practical. Scripts must not silently delete user data, alter production resources, or expose secrets.
4. Avoid dependencies when an existing Flutter/Dart tool can do the job.

## Ready when

Another developer can understand and safely run the tool from its documentation.
