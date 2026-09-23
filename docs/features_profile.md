# Comprehensive Documentation for `profile`

**Path:** `lib/features/profile/`

## Subdirectories
- `widgets/`

## Files

### 📄 `profile_screen.dart`
**Key Imports:**
- `import 'dart:async';`
- `import 'dart:io';`
- `import 'package:image_picker/image_picker.dart';`
- `import 'package:provider/provider.dart';`
- `import '../../core/utils/responsive.dart';`
- *...and 10 more*

**Defined Types & Details:**

#### `ProfileScreen` extends StatelessWidget
- **Methods:**
  - `ProfileScreen()`
  - `build()`

#### `_ProfileBody` extends StatefulWidget
- **Methods:**
  - `_ProfileBody()`
  - `createState()`

#### `_ProfileBodyState` extends State<_ProfileBody>
- **Fields / Properties:**
  - `_editing`
  - `_uploadingPhoto`
  - `_previewPath`
  - `_uploadError`
  - `_uploadSuccess`
  - `false`
  - `true`
  - `user`
  - `s`
- **Methods:**
  - `initState()`
  - `_validateFile()`
  - `setState()`
  - `dispose()`
  - `_pickAndUploadPhoto()`
  - `_removePhoto()`
  - `unawaited()`
  - `build()`
  - `_EditButton()`
  - `_buildPageHeader()`

#### `_AvatarCard` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `uploading`
  - `previewPath`
  - `uploadError`
  - `uploadSuccess`
  - `onTap`
  - `onRemove`
  - `onDismissError`
  - `s`
- **Methods:**
  - `build()`

#### `_VerifiedBadge` extends StatelessWidget
- **Fields / Properties:**
  - `user`
  - `s`
- **Methods:**
  - `_VerifiedBadge()`
  - `build()`

#### `_EditButton` extends StatelessWidget
- **Fields / Properties:**
  - `onTap`
  - `s`
- **Methods:**
  - `_EditButton()`
  - `build()`

---

