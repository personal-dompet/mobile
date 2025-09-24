# Assets Directory

This directory contains all static assets used in the mobile application.

## Purpose

The assets directory holds:
- Images and icons
- Fonts
- Localization files
- Other static resources

## Structure

- `/images` - Image assets (PNG, JPG, SVG)
- `/icons` - Application icons
- `/fonts` - Custom fonts
- `/translations` - Localization files (JSON)

## Usage

Assets are declared in `pubspec.yaml` and referenced in the code using `AssetImage` or similar widgets.

## Example

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
    - assets/translations/
```

```dart
// In code
Image.asset('assets/images/logo.png')
```