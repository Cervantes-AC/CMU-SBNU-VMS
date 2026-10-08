# 05. Auth and Security

## Folder purpose

Sign-in and session flows, account approval, role policy, privacy controls, and security review.

## Current status

Firebase is not initialized in the app. No application authentication or authorization flow is implemented.

## Plan

1. Confirm roles, identity verification, account approval, recovery, and access revocation rules.
2. Implement sign-in, sign-out, session state, pending/denied states, and safe session cleanup.
3. Enforce role and record permissions in trusted rules/operations; never trust client-set role or approval fields.
4. Review data minimization, logging, retention, and threat protections before sensitive workflows.
5. Defer incident response, QR duty, SOS, exports, and administrative data tools until their policies are approved.

## Ready when

The access matrix is approved and both allowed and denied access paths are checked locally.
