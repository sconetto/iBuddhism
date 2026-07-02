## ADDED Requirements

### Requirement: Image picker permissions are correctly handled
The system SHALL verify that `image_picker` usage respects platform permission requirements and handles denial gracefully.

#### Scenario: Permission denied on iOS
- **WHEN** the user denies photo library permission on iOS
- **THEN** the app SHALL show a descriptive message explaining why access is needed AND NOT crash

#### Scenario: Permission denied on Android
- **WHEN** the user denies camera or storage permission on Android
- **THEN** the app SHALL handle the denial gracefully without crashing

### Requirement: Temporary files are cleaned up
The system SHALL verify that temporary files created by `image_picker` are cleaned up after use.

#### Scenario: Temp file deleted after profile photo update
- **WHEN** a profile photo is picked and saved
- **THEN** any temporary file created by `image_picker` SHALL be deleted after the image is persisted
