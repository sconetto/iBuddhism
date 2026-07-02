## 1. Dependency Vulnerability Scan

- [ ] 1.1 Run `dart pub outdated` and document all outdated dependencies
- [ ] 1.2 Run semgrep SUPPLY_CHAIN scan on project lockfile
- [ ] 1.3 Review each outdated dependency's changelog for security advisories
- [ ] 1.4 Update pubspec.yaml with patched versions for any vulnerable dependencies
- [ ] 1.5 Run `flutter pub get` and `flutter test` to verify updates don't break anything

## 2. Local Storage Audit

- [ ] 2.1 Search codebase for all `shared_preferences` get/set/remove calls
- [ ] 2.2 Document every storage key with its data type, purpose, and sensitivity classification
- [ ] 2.3 Flag any key storing data beyond expected profile/calendar state
- [ ] 2.4 Remediate or document-as-accepted any findings from step 2.3

## 3. Image Picker Security Audit

- [ ] 3.1 Review `image_picker` integration for permission handling on Android (Manifest)
- [ ] 3.2 Review `image_picker` integration for permission handling on iOS (Info.plist)
- [ ] 3.3 Verify temporary file cleanup after photo is persisted
- [ ] 3.4 Add gracefull handling for permission-denied scenarios if missing

## 4. Input Validation Review

- [ ] 4.1 Identify all free-text input fields (profile name, bio)
- [ ] 4.2 Add length limits (100 chars name, 500 chars bio) if not already present
- [ ] 4.3 Verify CJK/Unicode encoding round-trips correctly through persistence and display

## 5. Release Hardening

- [ ] 5.1 Search codebase for unguarded `print()`/`debugPrint()` statements
- [ ] 5.2 Verify no debug-only UI elements are visible in release mode
- [ ] 5.3 Add `--obfuscate` and `--split-debug-info` to Android release build config
- [ ] 5.4 Add `--obfuscate` and `--split-debug-info` to iOS release build config
- [ ] 5.5 Build both release targets and verify they compile

## 6. Security Report

- [ ] 6.1 Compile all findings and remediations into a `SECURITY.md` document
- [ ] 6.2 Run `flutter analyze` and `flutter test` to confirm no regressions
