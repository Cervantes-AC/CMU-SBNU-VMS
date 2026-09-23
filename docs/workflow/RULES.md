# CMU SBNU VMS - Project Rules (Dos and Don\'ts)

## Overview

This document outlines the essential rules, best practices, and constraints for the CMU SBNU VMS project. Follow these guidelines to ensure code quality, security, and project consistency.

---

## Table of Contents

1. [Code Quality Rules](#1-code-quality-rules)
2. [Security Rules](#2-security-rules)
3. [Data Handling Rules](#3-data-handling-rules)
4. [Git & Version Control Rules](#4-git--version-control-rules)
5. [Firebase & Backend Rules](#5-firebase--backend-rules)
6. [Documentation Rules](#6-documentation-rules)
7. [Code Review Rules](#7-code-review-rules)
8. [Testing Rules](#8-testing-rules)
9. [General Project Rules](#9-general-project-rules)

---

## 1. Code Quality Rules

### ? DO

- **Format your code** before committing: `dart format .`
- **Run analyzer** before every commit: `flutter analyze`
- **Fix all analyzer errors** before requesting review
- **Follow Dart/Flutter conventions** and style guides
- **Keep functions small and focused** (single responsibility)
- **Use meaningful variable and function names**
- **Add comments** for complex logic (but prefer self-documenting code)
- **Handle errors gracefully** with proper try-catch where needed
- **Use `const` constructors** where possible for performance
- **Null-safe code**: Always handle nullable types properly

### ? DON\'T

- **Don\'t ignore analyzer warnings** - fix them or justify why they\'re acceptable
- **Don\'t commit unformatted code**
- **Don\'t use `print()` for debugging** in production code (use proper logging)
- **Don\'t leave TODO comments** without creating a task for them
- **Don\'t hardcode values** that should be constants or configuration
- **Don\'t use deprecated APIs** without a migration plan
- **Don\'t add unnecessary dependencies**
- **Don\'t copy-paste code** without understanding it

---

## 2. Security Rules

### ? DO

- **Follow least-privilege access** for all user roles
- **Validate all user inputs** on both client and server
- **Use Firebase Security Rules** to protect data
- **Implement proper authentication checks** before sensitive operations
- **Audit all actions** that modify data
- **Use environment-specific configurations** (dev vs production)
- **Review dependencies** for known vulnerabilities
- **Keep Firebase SDK and dependencies updated**

### ? DON\'T

- **Don\'t hardcode credentials**, API keys, or secrets in code
- **Don\'t store sensitive data** in client-side storage without encryption
- **Don\'t trust client-side validation alone** - always validate on server
- **Don\'t expose administrative functions** to regular users
- **Don\'t bypass security rules** for convenience
- **Don\'t use the prototype Firebase project** (`nsrc-vms`) for this app
- **Don\'t share service account keys** or credentials

---

## 3. Data Handling Rules

### ? DO

- **Use mock data** for development and testing
- **Anonymize any sample data** used in documentation
- **Follow privacy regulations** for volunteer data
- **Implement data retention policies** where applicable
- **Document data schemas** and relationships
- **Use proper data models** with validation

### ? DON\'T

- **Don\'t use real volunteer data** until open decisions are closed
- **Don\'t commit real data** to the repository
- **Don\'t share volunteer information** without proper authorization
- **Don\'t bypass data validation**
- **Don\'t assume data exists** - always check for null/missing data

> **Important**: See [Open Decisions Register](docs/94-open-decisions-register.md) for the current status of data usage permissions.

---

## 4. Git & Version Control Rules

### ? DO

- **Create feature branches** for all changes: `T-xx-short-purpose`
- **Branch from main** (the integration branch)
- **Commit frequently** with clear, descriptive messages
- **Pull latest changes** before starting work
- **Resolve conflicts** before merging
- **Delete merged branches** to keep repository clean
- **Use .gitignore** to exclude unnecessary files

### ? DON\'T

- **Don\'t commit directly to main**
- **Don\'t commit generated files** (`.dart_tool/`, `build/`, etc.)
- **Don\'t commit large binary files** (use Git LFS if needed)
- **Don\'t commit IDE-specific files** that belong in `.gitignore`
- **Don\'t rewrite history** on shared branches
- **Don\'t force push** to shared branches

### Commit Message Format

```
T-xx: Brief description of change

Optional: More details about the change
- Bullet point 1
- Bullet point 2
```

### Examples

| ? Good | ? Bad |
|---------|--------|
| `T-01: Fix analyzer errors in firebase_options` | `fix stuff` |
| `T-05: Add volunteer login screen` | `updates` |
| `T-12: Port attendance module from prototype` | `commit` |

---

## 5. Firebase & Backend Rules

### ? DO

- **Use the project of record**: `cmu-sbnu-vms`
- **Configure Firebase properly** for each environment
- **Test with Firebase Emulator Suite** for local development
- **Document backend changes** in appropriate ADRs
- **Version your security rules** and test them
- **Monitor Cloud Functions** for errors

### ? DON\'T

- **Don\'t use the prototype project** (`nsrc-vms`) - EVER
- **Don\'t deploy to production** without proper testing
- **Don\'t skip testing security rules**
- **Don\'t modify production data** without authorization
- **Don\'t ignore Firebase quotas and limits**

### Project Identity

| Attribute | Correct Value |
|-----------|---------------|
| Firebase Project | `cmu-sbnu-vms` |
| Package Name | `cmu_sbnu_vms` |
| Application ID | `com.cmu.sbnu.vms.cmu_sbnu_vms` |

> **Warning**: Using the wrong Firebase project can cause data corruption and security issues.

---

## 6. Documentation Rules

### ? DO

- **Document architectural decisions** in ADRs
- **Update changelog** with every significant change
- **Keep traceability matrix** up to date
- **Document public APIs** and their usage
- **Write clear commit messages**
- **Update feature documentation** when adding features
- **Use markdown consistently** for all documentation

### ? DON\'T

- **Don\'t leave documentation outdated** after changes
- **Don\'t skip documenting decisions** that affect architecture
- **Don\'t create duplicate documentation** - update existing docs
- **Don\'t use vague language** - be specific and clear

---

## 7. Code Review Rules

### ? DO (For Authors)

- **Self-review your code** before requesting review
- **Run all checks** and include results in PR
- **Respond to all review comments** promptly
- **Explain your reasoning** for non-obvious decisions
- **Keep PRs small and focused**

### ? DO (For Reviewers)

- **Review promptly** to avoid blocking progress
- **Be constructive** in feedback
- **Focus on important issues** first (logic, security, design)
- **Verify checks passed** before approving
- **Test changes** if they affect critical functionality

### ? DON\'T

- **Don\'t approve** code that hasn\'t passed all checks
- **Don\'t leave PRs hanging** for extended periods
- **Don\'t take criticism personally** - it\'s about the code
- **Don\'t approve your own code**

---

## 8. Testing Rules

### ? DO

- **Write tests** for new functionality
- **Run all tests** before committing: `flutter test`
- **Test edge cases** and error conditions
- **Use meaningful test names** that describe what\'s being tested
- **Keep tests fast** and deterministic
- **Mock external dependencies** appropriately

### ? DON\'T

- **Don\'t skip tests** for "simple" changes
- **Don\'t write flaky tests** that sometimes fail
- **Don\'t test implementation details** - test behavior
- **Don\'t commit failing tests**

### Test Command

```bash
flutter test
```

---

## 9. General Project Rules

### ? DO

- **Follow the Definition of Ready** before starting work
- **Follow the Definition of Done** before considering work complete
- **Check the Open Decisions Register** before making decisions
- **Review relevant ADRs** before architectural changes
- **Keep changes small** and focused
- **Communicate** with the team about your work
- **Ask questions** when unsure

### ? DON\'T

- **Don\'t start work** on blocked tasks
- **Don\'t make architectural decisions** without documenting them
- **Don\'t use real data** without proper authorization
- **Don\'t bypass quality gates**
- **Don\'t work in isolation** - keep the team informed

---

## Quick Reference Card

### The Absolute Must-Follow Rules

| Rule | Consequence of Violation |
|------|--------------------------|
| Never commit credentials | Security breach |
| Never use `nsrc-vms` project | Data corruption, security issues |
| Never commit real volunteer data | Privacy violation |
| Always run `dart format .` | Code inconsistency |
| Always run `flutter analyze` | Code quality issues |
| Always run `flutter test` | Undetected bugs |
| Never commit to main directly | Broken integration |

### The Should-Follow Rules

| Rule | Reason |
|------|--------|
| Document decisions in ADRs | Knowledge preservation |
| Update changelog | Change tracking |
| Keep PRs small | Faster reviews |
| Respond to reviews promptly | Team velocity |
| Use meaningful names | Code readability |

---

## Enforcement

### Automated Checks

These are enforced automatically:
- ? Code formatting (`dart format .`)
- ? Static analysis (`flutter analyze`)
- ? Tests (`flutter test`)
- ? Git branch naming convention

### Manual Checks

These require human verification:
- ? Code review approval
- ? Definition of Done checklist
- ? Security and privacy compliance
- ? Documentation completeness

---

## Questions?

If you\'re unsure about any rule:

1. Check the [Development Workflow](DEVELOPMENT_WORKFLOW.md)
2. Review relevant [ADRs](docs/adr/)
3. Ask in the team channel
4. Consult the [Open Decisions Register](docs/94-open-decisions-register.md)

---

*Last updated: 2026-09-23*
