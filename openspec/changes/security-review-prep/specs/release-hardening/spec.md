## ADDED Requirements

### Requirement: Debug-mode assertions are guarded
The system SHALL verify that debug-only code (assertions, debug prints, debug UI elements) is not present in release builds or is properly guarded by `kReleaseMode` or `assert()` checks.

#### Scenario: No debug prints in release
- **WHEN** the app is built in release mode
- **THEN** there SHALL be no `print()` or `debugPrint()` statements that leak internal state

#### Scenario: Debug UI guarded
- **WHEN** the app is built in release mode
- **THEN** any debug-only UI elements or controls SHALL NOT be visible

### Requirement: Release build uses obfuscation
The system SHALL use Flutter's `--obfuscate` and `--split-debug-info` flags for release builds to hinder reverse engineering.

#### Scenario: Obfuscation enabled for Android release
- **WHEN** `flutter build apk --release` is run
- **THEN** the build SHALL include `--obfuscate` and `--split-debug-info` flags

#### Scenario: Obfuscation enabled for iOS release
- **WHEN** `flutter build ios --release` is run
- **THEN** the build SHALL include `--obfuscate` and `--split-debug-info` flags
