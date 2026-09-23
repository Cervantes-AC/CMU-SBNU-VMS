# CMU SBNU VMS - Workflow Documentation

## Overview

This folder contains documentation for the development workflow of the CMU SBNU VMS project.

---

## Contents

| Document | Description |
|----------|-------------|
| [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md) | Complete development workflow from task selection to deployment |
| [RULES.md](RULES.md) | Project rules, dos and don\'ts, and best practices |

---

## Quick Start

### Development Process

```
Task Selection -> Branch Creation -> Development -> Local Verification -> Review Request -> Merge -> Documentation Updates
```

### Before You Start

1. Read the [Rules](RULES.md) - know what you can and cannot do
2. Check the [Open Decisions Register](docs/94-open-decisions-register.md) - don\'t use real data yet
3. Pick an unblocked task from the sprint plan

### During Development

1. Create branch: `T-xx-short-purpose`
2. Write code following [Rules](RULES.md)
3. Run checks:
   - `dart format .`
   - `flutter analyze`
   - `flutter test`
4. Commit and push

### Before Requesting Review

- [ ] All rules followed
- [ ] Code formatted
- [ ] No analyzer errors
- [ ] All tests pass
- [ ] Results pasted in PR

---

## Key Documents

### In This Folder

| Document | Purpose |
|----------|---------|
| [DEVELOPMENT_WORKFLOW.md](DEVELOPMENT_WORKFLOW.md) | Step-by-step workflow guide |
| [RULES.md](RULES.md) | Dos and don\'ts, best practices |

### External References

These documents are in the parent `docs/` folder:

| Document | Purpose |
|----------|---------|
| [Implementation Baseline](docs/92-implementation-baseline.md) | Development standards and conventions |
| [Definition of Ready and Done](docs/96-definition-of-ready-and-done.md) | Quality checklists |
| [Sprint 0 Plan](docs/98-sprint-0-plan.md) | Current sprint tasks |
| [Prototype Port Plan](docs/99-prototype-port-and-identity-migration-plan.md) | Porting guide from prototype |
| [ADR Directory](docs/adr/) | Architecture Decision Records |
| [Open Decisions Register](docs/94-open-decisions-register.md) | Pending decisions |

---

## The Absolute Must-Follow Rules

| Rule | Consequence of Violation |
|------|--------------------------|
| **Never commit credentials** | Security breach |
| **Never use `nsrc-vms` project** | Data corruption, security issues |
| **Never commit real volunteer data** | Privacy violation |
| **Always run `dart format .`** | Code inconsistency |
| **Always run `flutter analyze`** | Code quality issues |
| **Always run `flutter test`** | Undetected bugs |
| **Never commit to main directly** | Broken integration |

> See [RULES.md](RULES.md) for the complete list of dos and don\'ts.

---

## Compliance Requirements

### Security Rules

- **Never commit credentials** or service-account keys
- **Never commit real volunteer data**
- **Never use the prototype Firebase project** (`nsrc-vms`)
  - Always use `cmu-sbnu-vms`

### Data Handling

- No real data may be used until open decisions are closed
- Follow privacy and legal constraints

---

## Quality Gates

All changes must pass:

1. **Code Formatting**: `dart format .`
2. **Static Analysis**: `flutter analyze` (no errors)
3. **Testing**: `flutter test` (all tests pass)
4. **Code Review**: Approved by reviewer(s)
5. **Definition of Done**: All checklist items complete

---

*Last updated: 2026-09-23*
