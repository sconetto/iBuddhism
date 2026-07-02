## ADDED Requirements

### Requirement: CI runs analyze and test on push
The system SHALL have a GitHub Actions workflow that runs `flutter analyze` and `flutter test` on every push to any branch and every pull request.

#### Scenario: Push triggers check
- **WHEN** code is pushed to any branch
- **THEN** a GitHub Actions workflow SHALL start AND run `flutter analyze` AND `flutter test`

#### Scenario: Pull request triggers check
- **WHEN** a pull request is opened or updated
- **THEN** a GitHub Actions workflow SHALL start AND run `flutter analyze` AND `flutter test`

#### Scenario: Check succeeds on passing code
- **WHEN** `flutter analyze` and `flutter test` both pass
- **THEN** the workflow SHALL report a green checkmark

#### Scenario: Check fails on broken code
- **WHEN** `flutter analyze` or `flutter test` fails
- **THEN** the workflow SHALL report a red ✗ AND block merge

### Requirement: Build runs on tag
The system SHALL have a workflow job that builds the app on git tag push.

#### Scenario: Tag push triggers build
- **WHEN** a git tag is pushed (e.g., `v1.0.0`)
- **THEN** a `flutter build apk --release` SHALL run AND the artifact SHALL be uploaded
