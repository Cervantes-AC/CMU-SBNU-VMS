# Comprehensive Documentation for `lib`

**Path:** `lib/`

## Subdirectories
- `core/`
- `data/`
- `features/`
- `shared/`
- `utils/`

## Files

### 📄 `app.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:firebase_auth/firebase_auth.dart';`
- `import 'package:provider/provider.dart';`
- `import 'package:shared_preferences/shared_preferences.dart';`
- `import 'core/cache/cache_service.dart';`
- *...and 50 more*

**Defined Types & Details:**

#### `NSRCApp` extends StatelessWidget
> Root widget of the CMU - SBNU Volunteer Management System.

- **Fields / Properties:**
  - `cacheService`
  - `connectivityService`
  - `builder`
  - `nonRestorable`
- **Methods:**
  - `build()`
  - `MaterialPageRoute()`
  - `smoothRoute()`

#### `_SplashRouter` extends StatefulWidget
- **Methods:**
  - `_SplashRouter()`
  - `createState()`

#### `_SplashRouterState` extends State<_SplashRouter>
- **Fields / Properties:**
  - `firebaseAuth`
  - `firebaseUser`
- **Methods:**
  - `initState()`
  - `_resolve()`
  - `build()`

#### `_NotificationTapHandler` extends StatefulWidget
- **Fields / Properties:**
  - `child`
- **Methods:**
  - `_NotificationTapHandler()`
  - `createState()`

#### `_NotificationTapHandlerState` extends State<_NotificationTapHandler>
- **Methods:**
  - `initState()`
  - `NotificationService()`
  - `dispose()`
  - `build()`

#### `_RouteObserver` extends NavigatorObserver
- **Fields / Properties:**
  - `name`
- **Methods:**
  - `_save()`
  - `didPush()`
  - `didReplace()`
  - `didPop()`

---

### 📄 `firebase_options.dart`
**Key Imports:**
- `import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;`

**Defined Types & Details:**

#### `DefaultFirebaseOptions` 
> Default [FirebaseOptions] for use with your Firebase apps.  Example: ```dart import 'firebase_options.dart'; // ... await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform, ); ```

- **Fields / Properties:**
  - `web`
  - `android`
  - `ios`

---

### 📄 `main.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'package:cloud_firestore/cloud_firestore.dart';`
- `import 'package:firebase_core/firebase_core.dart';`
- `import 'package:firebase_crashlytics/firebase_crashlytics.dart';`
- `import 'package:hive_flutter/hive_flutter.dart';`
- *...and 6 more*

**Defined Types & Details:**

#### `BootstrapFailureApp` extends StatelessWidget
- **Fields / Properties:**
  - `error`
- **Methods:**
  - `BootstrapFailureApp()`
  - `build()`

---

