## ADDED Requirements

### Requirement: Profile text fields have length limits
The system SHALL validate that profile name and bio fields do not exceed reasonable length limits before persisting.

#### Scenario: Name within limits
- **WHEN** the user saves a profile name under 100 characters
- **THEN** the name SHALL be persisted without truncation

#### Scenario: Name exceeds limit
- **WHEN** the user attempts to save a profile name over 100 characters
- **THEN** the value SHALL be truncated or rejected with a user-visible message

#### Scenario: Bio within limits
- **WHEN** the user saves a bio under 500 characters
- **THEN** the bio SHALL be persisted without truncation

### Requirement: Input encoding is preserved correctly
The system SHALL verify that text input preserves Unicode encoding (including CJK characters) without data loss.

#### Scenario: CJK characters in bio
- **WHEN** the user enters CJK characters in the bio field
- **THEN** the characters SHALL be persisted and displayed correctly without encoding corruption
