# Image Assets

This directory contains image assets for the CMU NSRC Volunteer Management System.

## Placeholder Files

The following files are **placeholder files** and must be replaced with the actual logo images before a production build:

| File | Description |
|---|---|
| `cmu_logo.png` | Central Mindanao University (CMU) official logo |
| `nsrc_logo.png` | National Service Reserve Corps (NSRC) official logo |

## Replacement Instructions

1. Obtain the official CMU and NSRC logo files in PNG format with transparent backgrounds.
2. Replace the placeholder files with the actual logo images, keeping the same filenames.
3. Recommended dimensions:
   - `cmu_logo.png` — at least 256×256 px, transparent background
   - `nsrc_logo.png` — at least 256×256 px, transparent background
4. Provide `@2x` and `@3x` variants if high-DPI support is required.

## Usage in Code

```dart
Image.asset('assets/images/cmu_logo.png')
Image.asset('assets/images/nsrc_logo.png')
```

These assets are declared in `pubspec.yaml` under `flutter.assets`.
