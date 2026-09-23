# CMU SBNU VMS - Development Workflow

## Overview

This document describes the development workflow for the CMU SBNU VMS project. It covers the process from task selection through code review and deployment.

---

## Development Process Overview

```
Task Selection -> Branch Creation -> Development -> Local Verification -> Review Request -> Merge -> Documentation Updates
```

---

## 1. Task Selection

### Sources of Work

Tasks can come from multiple sources:

| Source | Description | When to Use |
|--------|-------------|-------------|
| **Sprint Plan** | Approved sprint tasks | Current sprint work |
| **Feature Planning Template** | Approved feature packages | New feature development |
| **Prototype Port Plan** | Staged port from prototype | Migrating prototype modules |

### Prerequisites

Before starting a task, ensure:

- The task is **unblocked** (no dependencies pending)
- For prototype ports: all prerequisites are closed
- You understand the requirements and acceptance criteria
- Related ADRs have been reviewed if applicable

---

## 2. Branch Naming Convention

### Format

```
T-xx-short-purpose
```

### Examples

| Branch Name | Description |
|-------------|-------------|
| `T-01-fix-analyzer-errors` | Fix the 11 analyzer errors from T-01 |
| `T-05-add-auth-screen` | Add authentication screen |
| `T-12-port-volunteer-module` | Port volunteer management module from prototype |

### Guidelines

- Use **kebab-case** (lowercase with hyphens)
- Keep descriptions **short and clear**
- Include the **task number** if one exists
- Branch from the **integration branch** (main)

---

## 3. Development Workflow

### Step-by-Step Process

#### 3.1 Create Branch

```bash
# Ensure you're on main and up to date
git checkout main
git pull

# Create and switch to feature branch
git checkout -b T-xx-short-purpose
```

#### 3.2 Make Changes

- Keep changes **small and focused**
- Follow conventions in [Implementation Baseline](docs/92-implementation-baseline.md) §4
- Write code according to Flutter/Dart best practices
- Consider the Definition of Done requirements while coding

#### 3.3 Commit Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "T-xx: Brief description of change"
```

#### 3.4 Push Branch

```bash
git push -u origin T-xx-short-purpose
```

---

## 4. Local Verification (Before Review)

### Required Checks

Before requesting review, you **must** run:

```bash
# 1. Format code
dart format .

# 2. Run analyzer
flutter analyze

# 3. Run tests
flutter test
```

### Verification Checklist

| Check | Command | Expected Result |
|-------|---------|-----------------|
| Code Formatting | `dart format .` | All files formatted |
| Static Analysis | `flutter analyze` | No errors, minimal warnings |
| Tests | `flutter test` | All tests pass |

### Paste Results

Include the output of all three commands in your review request.

---

## 5. Code Review Process

### Before Requesting Review

Ensure you have:

- [ ] Run `dart format .` and commit formatting changes
- [ ] Run `flutter analyze` with no errors
- [ ] Run `flutter test` and all tests pass
- [ ] Pasted the results in your review request
- [ ] Updated relevant documentation (if applicable)
- [ ] Met Definition of Ready checklist (see [Definition of Ready and Done](docs/96-definition-of-ready-and-done.md))

### Review Request

1. Create a Pull Request (PR) or Merge Request (MR)
2. Include:
   - Clear description of changes
   - Link to the task/issue
   - Output of verification commands
   - Screenshots (if UI changes)
3. Request review from appropriate reviewers

### During Review

- Address all reviewer feedback
- Push additional commits as needed
- Re-run verification checks after changes

### Approval Criteria

Changes are ready to merge when:

- All review comments are addressed
- Definition of Done checklist is complete
- Changelog is updated
- Traceability matrix is updated (if applicable)
- ADRs are updated (if decisions changed)

---

## 6. Definition of Ready

### Before Starting Development

A task is ready when:

- [ ] Requirements are clearly defined
- [ ] Acceptance criteria are understood
- [ ] Dependencies are identified and available
- [ ] Implementation approach is planned
- [ ] Any needed ADRs are created/approved

See [Definition of Ready and Done](docs/96-definition-of-ready-and-done.md) for full checklist.

---

## 7. Definition of Done

### After Completing Development

A task is done when:

- [ ] All code is written and tested
- [ ] Code follows project conventions
- [ ] `dart format .` passes
- [ ] `flutter analyze` passes (no errors)
- [ ] `flutter test` passes
- [ ] Documentation is updated
- [ ] Changelog is updated
- [ ] Traceability matrix is updated (if applicable)
- [ ] ADRs are updated (if decisions changed)
- [ ] Code review is approved
- [ ] Changes are merged to integration branch

See [Definition of Ready and Done](docs/96-definition-of-ready-and-done.md) for full checklist.

---

## 8. Documentation Updates

### Required Updates

After completing a task, update:

| Document | When to Update |
|----------|----------------|
| **Changelog** | Every change |
| **Traceability Matrix** | When requirements are implemented |
| **ADRs** | When architectural decisions change |
| **Feature Documentation** | When new features are added |

### Documentation Location

- Project documentation: `docs/`
- Feature docs: `docs/features/`
| Architecture decisions: `docs/adr/`

---

## 9. Quality Gates

### Pre-Merge Requirements

All changes must pass:

1. **Code Formatting**: `dart format .`
2. **Static Analysis**: `flutter analyze` (no errors)
3. **Testing**: `flutter test` (all tests pass)
4. **Code Review**: Approved by reviewer(s)
5. **Definition of Done**: All checklist items complete

### Additional Checks for Specific Changes

| Change Type | Additional Checks |
|-------------|-------------------|
| Backend/Firebase changes | Test with Firebase Emulator or dev project |
| Security rules | Review security implications |
| User data handling | Verify privacy compliance |
| New dependencies | Review license and security |

---

## 10. Security & Compliance

### Critical Rules

- **Never commit credentials** or service-account keys
- **Never commit real volunteer data**
- **Never point builds at the prototype project** (`nsrc-vms`)
  - Always use the project of record: `cmu-sbnu-vms`
- Follow security guidelines in ADR-0007

### Data Handling

- No real data may be used until open decisions are closed
- See [Open Decisions Register](docs/94-open-decisions-register.md)
- Review privacy constraints in [Legal and Policy Constraints](docs/14-legal-and-policy-constraints.md)

---

## 11. Branching Strategy

### Branch Types

| Branch | Purpose | Lifetime |
|--------|---------|----------|
| `main` | Integration branch | Permanent |
| `T-xx-*` | Feature/task branches | Until merged |

### Merge Process

1. Ensure branch is up to date with main
2. Resolve any conflicts
3. Re-run all verification checks
4. Get review approval
5. Merge to main
6. Delete feature branch (optional)

---

## 12. Environment Setup

### Prerequisites

- Flutter 3.38.9 stable
- Dart 3.10.8
- Git
- Android SDK (for Android builds)
- Node.js + Firebase CLI (for backend work)

### Setup Commands

```bash
# Verify toolchain
flutter --version  # Should show 3.38.9 / Dart 3.10.8

# Install dependencies
flutter pub get

# For backend work
firebase emulators:start  # Or use dev project
```

See [Environment Setup](docs/51-environment-setup.md) for detailed instructions.

---

## 13. Quick Reference

### Common Commands

```bash
# Development
flutter pub get          # Install dependencies
dart format .            # Format code
flutter analyze          # Static analysis
flutter test             # Run tests
flutter run -d chrome    # Run on web
flutter run -d <device>  # Run on device

# Build
flutter build apk        # Android APK
flutter build web        # Web build

# Firebase (if needed)
firebase emulators:start # Start emulators
firebase deploy          # Deploy to Firebase
```

### Key Documentation Links

| Document | Purpose |
|----------|---------|
| [Implementation Baseline](docs/92-implementation-baseline.md) | Development standards |
| [Definition of Ready and Done](docs/96-definition-of-ready-and-done.md) | Quality checklists |
| [Sprint 0 Plan](docs/98-sprint-0-plan.md) | Current sprint tasks |
| [Prototype Port Plan](docs/99-prototype-port-and-identity-migration-plan.md) | Porting guide |
| [ADR Directory](docs/adr/) | Architecture decisions |
| [Open Decisions Register](docs/94-open-decisions-register.md) | Pending decisions |

---

## 14. Roles & Responsibilities

| Role | Responsibilities |
|------|------------------|
| **Developer** | Implement tasks, follow workflow, pass quality gates |
| **Reviewer** | Review code, ensure quality standards |
| **Product Owner** | Define requirements, prioritize tasks |
| **Maintainer** | Merge approved changes, maintain repository health |

---

## 15. Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Analyzer errors | Run `flutter analyze`, fix reported issues |
| Test failures | Run `flutter test`, debug and fix |
| Merge conflicts | Pull main, resolve conflicts, re-verify |
| Firebase config missing | See [ADR-0001](docs/adr/0001-backend-platform-and-environment-ownership.md) |

### Getting Help

- Check existing documentation in `docs/`
- Review ADRs for architectural decisions
- Consult the Implementation Baseline for conventions

---

*Last updated: 2026-09-23*
