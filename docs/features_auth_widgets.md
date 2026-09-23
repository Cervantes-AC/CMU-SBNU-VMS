# Comprehensive Documentation for `widgets`

**Path:** `lib/features/auth/widgets/`

## Files

### 📄 `auth_bg_painter.dart`
**Key Imports:**
- `import 'dart:math' as math;`
- `import '../../../core/utils/ui_helpers.dart';`
- `import 'auth_shared_widgets.dart';`

**Defined Types & Details:**

#### `AuthBgPainter` extends CustomPainter
- **Fields / Properties:**
  - `t`
- **Methods:**
  - `AuthBgPainter()`
  - `paint()`
  - `shouldRepaint()`

---

### 📄 `auth_branding_panel.dart`
**Key Imports:**
- `import 'dart:math' as math;`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../shared/widgets/logo_badge.dart';`
- `import 'auth_shared_widgets.dart';`

**Defined Types & Details:**

#### `AuthBrandingPanel` extends StatelessWidget
- **Fields / Properties:**
  - `logoAnim`
  - `scale`
  - `s`
  - `f`
- **Methods:**
  - `AuthBrandingPanel()`
  - `build()`

---

### 📄 `auth_shared_widgets.dart`
**Key Imports:**
- `import '../../../core/constants/app_colors.dart';`
- `import '../../../core/utils/responsive.dart';`

**Defined Types & Details:**

#### `AuthGradientButton` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `icon`
  - `loading`
  - `colors`
  - `onPressed`
  - `s`
- **Methods:**
  - `build()`

#### `AuthErrorBanner` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `s`
- **Methods:**
  - `AuthErrorBanner()`
  - `build()`

#### `AuthSuccessBanner` extends StatelessWidget
- **Fields / Properties:**
  - `message`
  - `s`
  - `isDark`
- **Methods:**
  - `AuthSuccessBanner()`
  - `build()`

#### `AuthTextField` extends StatelessWidget
- **Fields / Properties:**
  - `controller`
  - `label`
  - `hint`
  - `icon`
  - `keyboardType`
  - `obscure`
  - `suffixIcon`
  - `readOnly`
  - `onTap`
  - `maxLines`
  - `onSubmitted`
  - `textInputAction`
  - `s`
- **Methods:**
  - `build()`

#### `AuthSectionLabel` extends StatelessWidget
- **Fields / Properties:**
  - `text`
  - `colors`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `login_form.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/validators.dart';`
- `import '../../../data/models/extensions/mfa_code.dart';`
- *...and 5 more*

**Defined Types & Details:**

#### `_AuthStep` login, mfaChallenge }

#### `LoginForm` extends StatefulWidget
- **Methods:**
  - `LoginForm()`
  - `createState()`

#### `_LoginFormState` extends State<LoginForm>
- **Fields / Properties:**
  - `_step`
  - `_obscure`
  - `_rememberMe`
  - `_loading`
  - `_error`
  - `_successMessage`
  - `_mfaUser`
  - `_mfaGeneratedCode`
  - `_mfaUseBackupCode`
  - `s`
  - `null`
- **Methods:**
  - `initState()`
  - `_loadRememberedPreference()`
  - `setState()`
  - `dispose()`
  - `_submit()`
  - `debugPrint()`
  - `_verifyMfaCode()`
  - `_cancelMfa()`
  - `_forgotPassword()`
  - `_onEmailSubmitted()`
  - `_onPasswordSubmitted()`
  - `build()`
  - `_buildMfaChallenge()`

---

### 📄 `register_form.dart`
**Key Imports:**
- `import 'package:provider/provider.dart';`
- `import '../../../core/constants/app_constants.dart';`
- `import '../../../core/utils/responsive.dart';`
- `import '../../../data/services/auth_service.dart';`
- `import '../../../shared/result.dart';`
- *...and 3 more*

**Defined Types & Details:**

#### `RegisterForm` extends StatefulWidget
- **Methods:**
  - `RegisterForm()`
  - `createState()`

#### `_RegisterFormState` extends State<RegisterForm> with FormAutoSave
- **Fields / Properties:**
  - `_step`
  - `_loading`
  - `_done`
  - `_error`
  - `_obscure1`
  - `_obscure2`
  - `_selectedBirthdate`
  - `_gender`
  - `_selectedCollege`
  - `_selectedProgram`
  - `_selectedYearLevel`
  - `_selectedCompetency`
  - `_step3ShowErrors`
  - `s`
- **Methods:**
  - `initState()`
  - `initAutoSave()`
  - `onDraftRestored()`
  - `setState()`
  - `dispose()`
  - `_pickBirthdate()`
  - `_next()`
  - `_saveCurrentStepDraft()`
  - `_back()`
  - `_composeCourseAndYear()`
  - `_submit()`
  - `clearDraft()`
  - `build()`
  - `_buildStepContent()`
  - `_buildSuccess()`

#### `_StepProgressBar` extends StatelessWidget
- **Fields / Properties:**
  - `currentStep`
  - `colors`
  - `s`
  - `done`
  - `active`
  - `color`
- **Methods:**
  - `_StepProgressBar()`
  - `build()`

#### `_StepNavButtons` extends StatelessWidget
- **Fields / Properties:**
  - `step`
  - `loading`
  - `stepColor`
  - `onBack`
  - `onNext`
  - `onSubmit`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `register_steps.dart`
**Key Imports:**
- `import '../../../core/utils/responsive.dart';`
- `import '../../../core/utils/validators.dart';`
- `import '../../../shared/academic_dropdowns.dart';`
- `import '../../../shared/widgets/password_policy_indicator.dart';`
- `import 'auth_shared_widgets.dart';`

**Defined Types & Details:**

#### `RegisterStep1` extends StatelessWidget
- **Fields / Properties:**
  - `emailCtrl`
  - `passCtrl`
  - `pass2Ctrl`
  - `obscure1`
  - `obscure2`
  - `onToggleObscure1`
  - `onToggleObscure2`
  - `s`
  - `null`
- **Methods:**
  - `build()`
  - `_visibilityBtn()`

#### `RegisterStep2` extends StatelessWidget
- **Fields / Properties:**
  - `nameCtrl`
  - `studentIdCtrl`
  - `serialCtrl`
  - `bdCtrl`
  - `selectedBirthdate`
  - `gender`
  - `onPickDate`
  - `onGenderChanged`
- **Methods:**
  - `build()`

#### `_BirthdatePicker` extends StatelessWidget
- **Fields / Properties:**
  - `controller`
  - `selectedDate`
  - `onTap`
  - `s`
- **Methods:**
  - `build()`

#### `_GenderDropdown` extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `onChanged`
- **Methods:**
  - `_GenderDropdown()`
  - `build()`

#### `RegisterStep3` extends StatelessWidget
- **Fields / Properties:**
  - `selectedCollege`
  - `selectedProgram`
  - `selectedYearLevel`
  - `selectedCompetency`
  - `contactCtrl`
  - `showErrors`
  - `onAcademicChanged`
  - `onCompetencyChanged`
- **Methods:**
  - `build()`

#### `RegisterStep5` extends StatelessWidget
- **Fields / Properties:**
  - `checkboxes`
  - `onToggle`
  - `s`
- **Methods:**
  - `build()`

#### `_ConsentCheckbox` extends StatelessWidget
- **Fields / Properties:**
  - `index`
  - `label`
  - `checked`
  - `onToggle`
  - `s`
- **Methods:**
  - `build()`

#### `RegisterStep4` extends StatelessWidget
- **Fields / Properties:**
  - `currAddrCtrl`
  - `homeAddrCtrl`
  - `ecNameCtrl`
  - `ecNumberCtrl`
- **Methods:**
  - `build()`

---

