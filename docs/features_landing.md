# Comprehensive Documentation for `landing`

**Path:** `lib/features/landing/`

## Subdirectories
- `parts/`
- `widgets/`

## Files

### 📄 `landing_page.dart`
**Key Imports:**
- `import 'dart:math' as math;`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import '../../core/constants/app_constants.dart';`
- `import '../../core/utils/responsive.dart';`
- `import '../../core/utils/validators.dart';`
- *...and 1 more*

**Defined Types & Details:**

#### `LandingPage` extends StatefulWidget
> Redesigned CMU - SBNU Landing Page. Modern, clean design with proper overflow handling and responsive layout.

- **Methods:**
  - `LandingPage()`
  - `createState()`

#### `_LandingPageState` extends State<LandingPage>
- **Fields / Properties:**
  - `_selectedProgram`
  - `_showPrivacy`
  - `_contactSent`
  - `ctx`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `_scrollTo()`
  - `_setLandingState()`
  - `build()`

---

