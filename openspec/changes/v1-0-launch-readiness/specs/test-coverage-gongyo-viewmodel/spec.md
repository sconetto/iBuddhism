## ADDED Requirements

### Requirement: GongyoViewModel chapter selection is tested
The system SHALL have unit tests verifying that GongyoViewModel correctly toggles chapters on and off.

#### Scenario: Toggle chapter on
- **WHEN** `gongyoViewModel.toggleChapter(chapter)` is called for a disabled chapter
- **THEN** that chapter SHALL be marked as selected

#### Scenario: Toggle chapter off
- **WHEN** `gongyoViewModel.toggleChapter(chapter)` is called for an already-enabled chapter
- **THEN** that chapter SHALL be marked as deselected

#### Scenario: At least one chapter always selected
- **WHEN** the last remaining chapter is toggled off
- **THEN** it SHALL remain selected (cannot deselect the last chapter)

### Requirement: GongyoViewModel start/stop cycle is tested
The system SHALL have unit tests verifying the start/pause/advance/stop lifecycle of GongyoViewModel.

#### Scenario: Start sets reciting state
- **WHEN** `startRecitation()` is called
- **THEN** `isReciting` SHALL be `true`

#### Scenario: Stop resets state
- **WHEN** `stopRecitation()` is called while reciting
- **THEN** `isReciting` SHALL be `false` AND `currentLineIndex` SHALL be `0`

#### Scenario: Pause toggles
- **WHEN** `pauseOrResume()` is called while reciting
- **THEN** `isPaused` SHALL toggle

#### Scenario: Advance moves to next line
- **WHEN** `advanceLine()` is called
- **THEN** `currentLineIndex` SHALL increment by 1

### Requirement: GongyoViewModel loop mode is tested
The system SHALL have unit tests verifying the loop (repeat) modes of GongyoViewModel.

#### Scenario: No loop stops at end
- **WHEN** loop mode is `none` AND the last line is reached
- **THEN** recitation SHALL stop automatically

#### Scenario: Chapter loop restarts chapter
- **WHEN** loop mode is `chapter` AND the last line of the chapter is reached
- **THEN** the line index SHALL reset to the chapter start

#### Scenario: All loop restarts from beginning
- **WHEN** loop mode is `all` AND the last line is reached
- **THEN** the line index SHALL reset to `0`
