# iBuddhism

iBuddhism is a minimalist Flutter companion app for practitioners of Nichiren
Daishonin Buddhism. It focuses on helping users perform Gongyo recitation
with a clean, distraction-free experience, including rhythmic reading,
chapter selection, and progress tracking.

## Features

- Rhythmic Gongyo reading with Japanese romanization + original Chinese text.
- Chapter selection (Hoben-pon, Juryo-hon, or both).
- Built-in local library resources (Portuguese content stored on-device).
- Progress calendar with monthly goals and recitation states.
- Profile with name, bio, avatar color/photo, and weekly goal.
- Liquid glass-style bottom navigation bar and Gongyo playback controls.
- Light/dark/auto themes and i18n (English + Portuguese).

## Tech Stack

- Flutter (Dart)
- Local storage: `shared_preferences`, device file system (`path_provider`)
- Media: `image_picker`
- i18n: `flutter_localizations`, `intl`, ARB + `l10n.yaml`
- UI: `liquid_glass_renderer`, Material 3

## Requirements

- Flutter SDK (stable)
- Xcode (for iOS builds)
- Android Studio / SDK (for Android builds)
- CocoaPods (for iOS dependencies)

## Configuration Notes

- iOS privacy strings are set in `ios/Runner/Info.plist`:
  `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`.
- Localization configuration: `l10n.yaml` and ARB files in `lib/l10n/`.
- App icon generation uses `flutter_launcher_icons.yaml`.

## Local Development

Install dependencies:

```
flutter pub get
```

Generate localizations:

```
flutter gen-l10n
```

Run on a device or emulator:

```
flutter run
```

## Tests

```
flutter test
```

## Build

Android:

```
flutter build apk
flutter build appbundle
```

iOS (requires Xcode on macOS):

```
flutter build ios
```

## License

This project is licensed under the GNU General Public License v3.0.
See `LICENSE` for details.
