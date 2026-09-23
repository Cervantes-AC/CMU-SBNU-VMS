# Auth Feature Documentation

## Overview
The `auth` feature module (`lib/features/auth`) is responsible for user authentication and onboarding. It provides a robust and responsive user interface for logging in, multi-factor authentication (MFA), and a comprehensive multi-step registration process for volunteers.

## Features
- **Responsive Layout**: Adapts between a wide layout (with a branding panel) on desktop/tablet and a narrow layout on mobile devices.
- **Login with MFA**: Secure login supporting password authentication, "Remember Me" sessions, and an MFA challenge step (SMS/Authenticator or backup codes).
- **Multi-Step Registration**: A guided 5-step registration wizard that collects comprehensive user data.
- **Auto-Save Drafts**: The registration form saves partially completed inputs locally so users don't lose progress if they navigate away.
- **Animated UI**: Uses a custom animated blob background and smooth transitions between tabs and form steps to enhance UX.

## Architecture & Functions

### Core Components
- **`AuthScreen`** (`auth_screen.dart`): The main entry point for the authentication flow. It handles the responsive layout orchestration, background animations, and toggling between the login and registration tabs.
- **`LoginForm`** (`widgets/login_form.dart`): 
  - Connects to `AuthService` for standard login.
  - Connects to `MfaService` to handle multi-factor challenges if enabled for the user.
  - Supports toggling "Remember Me" and sending "Forgot Password" emails.
- **`RegisterForm`** (`widgets/register_form.dart`):
  - Orchestrates the registration flow.
  - Uses a `FormAutoSave` mixin to persist draft inputs.
  - Gathers form state and sends a `RegistrationData` object to the `AuthService` upon completion.

### Registration Steps (`widgets/register_steps.dart`)
The registration process is divided into 5 focused sub-widgets:
1. **`RegisterStep1` (Account Setup)**: Email and password fields. Integrates a password policy indicator.
2. **`RegisterStep2` (Personal Info)**: Full Name, Student ID, Serial Number, Birthdate (via a custom picker), and Gender.
3. **`RegisterStep3` (Academic & Skills)**: Cascading dropdowns for College/Program/Year Level, Competency selection, and Contact Number.
4. **`RegisterStep4` (Address & Emergency)**: Current and Home addresses, Emergency Contact details.
5. **`RegisterStep5` (Data Privacy)**: A 5-point checklist ensuring consent under the Data Privacy Act.

## UI/UX Design

- **Glassmorphism & Gradients**: The main form card uses a glass-like container (`Glass.bg`) overlaid on a custom animated canvas (`AuthBgPainter`). Form buttons (`AuthGradientButton`) use gradients indicating the active/loading state.
- **Branding Panel** (`AuthBrandingPanel`): Displayed on larger screens. It features animated logos and benefit pills that scale into view.
- **Shared Widgets** (`widgets/auth_shared_widgets.dart`): Standardizes the visual identity across auth views with components like `AuthTextField`, `AuthErrorBanner`, `AuthSuccessBanner`, and a shared color palette (e.g., `authGreen`, `authGold`).

## Connections and Dependencies

- **Services**: Relies heavily on `AuthService` (`data/services/auth_service.dart`) for remote operations and `MfaService` (`data/services/mfa/mfa_service.dart`) for 2FA validation.
- **Models**: Binds UI state to `AppUser` and `RegistrationData`.
- **Core Components**: Uses common utilities like `AppValidators` for input validation and `Responsive` extensions for adaptive sizing.
- **Shared Features**: Uses `AcademicDropdowns` and `PasswordPolicyIndicator` from the `shared` module for specialized inputs.
