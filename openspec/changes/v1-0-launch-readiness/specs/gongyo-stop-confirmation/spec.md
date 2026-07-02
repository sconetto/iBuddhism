## ADDED Requirements

### Requirement: Stop confirmation dialog is shown when recitation is active
The system SHALL display a confirmation dialog when the user taps the stop button during an active recitation.

#### Scenario: Stop during active recitation
- **WHEN** the user taps the stop button while recitation is in progress
- **THEN** a confirmation dialog SHALL appear with "Confirm" and "Cancel" actions

#### Scenario: Cancel keeps recitation going
- **WHEN** the confirmation dialog is shown AND the user taps "Cancel"
- **THEN** the dialog SHALL dismiss AND recitation SHALL continue uninterrupted

#### Scenario: Confirm stops recitation
- **WHEN** the confirmation dialog is shown AND the user taps "Confirm"
- **THEN** recitation SHALL stop AND the recitation state SHALL reset to idle

### Requirement: No confirmation when recitation is idle
The system SHALL NOT show the confirmation dialog when the recitation is already idle.

#### Scenario: Stop tapped while idle
- **WHEN** the recitation is idle AND the user taps the stop button
- **THEN** no dialog SHALL appear (idle state is preserved)
