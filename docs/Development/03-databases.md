# 03. Databases

## Folder purpose

Database structure, security rules, indexes, migrations, and data lifecycle documentation.

## Current status

`firestore.rules` denies client access; `firestore.indexes.json` contains no indexes. No approved application schema is established.

## Plan

1. Decide approved data fields, ownership, retention, and correction rules before creating collections.
2. Document typed schemas and ownership for each approved workflow.
3. Keep Firestore access deny-by-default until specific rules are reviewed.
4. Add indexes and migration steps only when required by an approved schema or query.
5. Validate rules against synthetic local data before enabling access.

## Ready when

The workflow's schema, access matrix, retention policy, and local rule checks are documented.
