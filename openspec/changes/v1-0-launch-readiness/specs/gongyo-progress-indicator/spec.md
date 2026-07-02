## ADDED Requirements

### Requirement: ViewModel exposes total line count
The system SHALL compute and expose the total number of lines in the current Gongyo recitation based on the selected chapters.

#### Scenario: Single chapter selected
- **WHEN** the user selects only Hoben-pon
- **THEN** `totalLines` SHALL equal the number of verses in Hoben-pon

#### Scenario: Both chapters selected
- **WHEN** the user selects both Hoben-pon and Juryo-hon
- **THEN** `totalLines` SHALL equal the sum of verses in both chapters

### Requirement: Progress indicator is displayed during recitation
The system SHALL display a compact progress label showing "current line / total lines" while recitation is active.

#### Scenario: Indicator visible during playback
- **WHEN** recitation is in progress
- **THEN** a label displaying "<currentLine> / <totalLines>" SHALL be visible on the Gongyo screen

### Requirement: Progress indicator updates on line advance
The system SHALL update the progress indicator each time the highlighted line advances.

#### Scenario: Line advances
- **WHEN** the current highlighted line advances to the next verse
- **THEN** the current-line number in the progress indicator SHALL increment by 1

### Requirement: Progress indicator updates on chapter switch
The system SHALL update the progress indicator's total line count when the user changes chapter selection mid-recitation.

#### Scenario: Toggle chapter during recitation
- **WHEN** the user toggles a chapter while recitation is active
- **THEN** the total line count SHALL be recomputed based on the new chapter selection
