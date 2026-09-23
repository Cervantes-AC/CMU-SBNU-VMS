# CMU SBNU VMS - Project Description

## Overview

**CMU SBNU VMS** (Central Mindanao University School-Based NSRC Units Volunteer Management System) is a Flutter-based application designed for managing volunteer operations at Central Mindanao University\'s School-Based National Service Reserve Corps (NSRC) units.

The application serves as a role-aware volunteer operations tool that handles volunteer records, events, attendance tracking, incident reporting, and unit communication - all with least-privilege access controls and auditable actions.

---

## Project Identity

| Attribute | Value |
|-----------|-------|
| **Package Name** | `cmu_sbnu_vms` |
| **Application Type** | Flutter (Mobile + Web) |
| **Backend Platform** | Firebase |
| **Firebase Project** | `cmu-sbnu-vms` |
| **Version** | `1.0.0+1` |
| **Target SDK** | Flutter 3.38.9 / Dart 3.10.8 |

---

## Purpose & Goals

The primary goal of this project is to provide a comprehensive volunteer management system for the CMU SBNU units with the following objectives:

1. **Volunteer Record Management** - Maintain accurate records of all volunteers
2. **Event Management** - Organize and track unit events
3. **Attendance Tracking** - Monitor volunteer participation and duty attendance
4. **Incident Reporting** - Enable reporting and management of incidents
5. **Unit Communication** - Facilitate communication within the unit
6. **Role-Based Access** - Implement least-privilege access controls
7. **Auditable Actions** - Maintain audit trails for all actions

---

## Technology Stack

### Frontend
- **Framework**: Flutter (Dart)
- **Platforms**: Android, iOS, Web, Windows, macOS, Linux
- **UI Icons**: Cupertino Icons (iOS-style)

### Backend
- **Platform**: Firebase
- **Services**: Authentication, Firestore (Database), Cloud Messaging, Storage, Crashlytics, Cloud Functions, Hosting

### Development Tools
- **Code Quality**: flutter_lints
- **Testing**: Flutter Test framework

---

## Target Personas

| Persona | Primary Experience |
|---------|-------------------|
| **Member** | Personal service hours, duty QR scanning, upcoming events, emergency alerts, incident reporting |
| **Officer** | Operations management, event & attendance handling, QR duty creation/monitoring, incident response, mission reports |
| **Admin / Super Admin** | Full system control: user management, analytics, audit logs, database browsing, backup/restore, import/export, announcements, incident review |
| **Organization** | Incident live feed and embedded tactical map view |

---

## Current Project Status

**As of 2026-09-23**: This repository is currently in the **planning and setup phase**. No product features have been implemented yet.

| Component | Status |
|-----------|--------|
| Application Code | Starter template (`lib/main.dart` is Flutter counter starter) |
| Dependencies | `cupertino_icons` + `flutter_lints` |
| Firebase Configuration | Client configuration exists for `cmu-sbnu-vms` project |
| Backend (Rules/Indexes) | Not yet implemented |
| Tests | One starter widget test |

---

## Relationship to Prototype

This repository (`cmu_sbnu_vms`) is the **project of record**. It supersedes an earlier prototype built under:
- **Package**: `cmu_nsrc_app`
- **Firebase Project**: `nsrc-vms`
- **Application ID**: `com.nsrc.nsrc_vms`

The prototype serves as **design input** only. Its code does not run in this repository, and no data, seed files, or credentials come from it. See ADR-0001 and ADR-0009 for details.

The porting plan for migrating prototype modules is documented in [docs/99-prototype-port-and-identity-migration-plan.md](docs/99-prototype-port-and-identity-migration-plan.md).

---

## Repository Structure

```
cmu_sbnu_vms/
+-- lib/                # Application source code
+-- test/               # Tests
+-- docs/               # Planning set, ADRs, documentation
+-- android/            # Android platform host
+-- ios/                # iOS platform host
+-- web/                # Web platform host
+-- windows/            # Windows platform host
+-- macos/              # macOS platform host
+-- linux/              # Linux platform host
+-- firebase.json       # Firebase platform configuration
+-- pubspec.yaml        # Flutter package configuration
+-- README.md           # Project README
```

---

## Documentation Navigation

| If you are... | Start reading here |
|---------------|-------------------|
| **Developer** about to write code | [docs/README.md](docs/README.md) ? [docs/92-implementation-baseline.md](docs/92-implementation-baseline.md) |
| **Setting up** a development machine | [docs/51-environment-setup.md](docs/51-environment-setup.md) |
| **Product Owner** or sponsor | [docs/00-project-overview.md](docs/00-project-overview.md) ? [docs/04-project-scope.md](docs/04-project-scope.md) |
| **Reviewing** safety, privacy, or risk | [docs/DEVELOPMENT-READINESS.md](docs/DEVELOPMENT-READINESS.md) |
| **Understanding** the target product | [docs/00-project-overview.md](docs/00-project-overview.md) ? [SBNU Application Project.md](SBNU%20Application%20Project.md) |
| **Porting** a prototype module | [docs/99-prototype-port-and-identity-migration-plan.md](docs/99-prototype-port-and-identity-migration-plan.md) |

---

## Key Documentation Files

- [docs/00-project-overview.md](docs/00-project-overview.md) - High-level project overview
- [docs/04-project-scope.md](docs/04-project-scope.md) - Project scope and boundaries
- [docs/92-implementation-baseline.md](docs/92-implementation-baseline.md) - Development standards and conventions
- [docs/96-definition-of-ready-and-done.md](docs/96-definition-of-ready-and-done.md) - Quality checklists
- [docs/98-sprint-0-plan.md](docs/98-sprint-0-plan.md) - Sprint planning
- [docs/99-prototype-port-and-identity-migration-plan.md](docs/99-prototype-port-and-identity-migration-plan.md) - Porting strategy
- [docs/adr/](docs/adr/) - Architecture Decision Records (ADRs)
- [docs/94-open-decisions-register.md](docs/94-open-decisions-register.md) - Open decisions tracker

---

## Contributing Guidelines

1. Pick an unblocked task from the sprint plan or approved feature package
2. Create a feature branch from the integration branch (`T-xx-short-purpose`)
3. Keep changes small and follow conventions in the implementation baseline
4. Before requesting review:
   - Run `dart format .`
   - Run `flutter analyze`
   - Run `flutter test`
   - Paste the results
5. Meet checklists in the Definition of Ready and Done
6. Update changelog, traceability matrix, and ADRs if decisions changed

---

## Important Notes

- **Never commit credentials**, service-account keys, or real volunteer data
- **Never point a build at the prototype project `nsrc-vms`** - always use `cmu-sbnu-vms`
- **No real data may be used** until open decisions in the register are closed
- **No license file is present** - treat code as internal until distribution terms are confirmed

---

## License & Ownership

This project is internal to CMU SBNU until the sponsor and repository owner confirm distribution terms (see open decisions D-01, D-18).

---

*Last updated: 2026-09-23*
