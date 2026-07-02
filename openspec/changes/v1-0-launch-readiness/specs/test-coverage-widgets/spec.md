## ADDED Requirements

### Requirement: Gongyo controls widget test exists
The system SHALL have a widget test that verifies the Gongyo screen renders play/pause/stop buttons.

#### Scenario: Controls visible on Gongyo screen
- **WHEN** the Gongyo screen is rendered
- **THEN** the play/pause and stop buttons SHALL be present

#### Scenario: Controls respond to tap
- **WHEN** the play button is tapped on the Gongyo screen
- **THEN** recitation SHALL start AND the play button SHALL be replaced by the pause button

### Requirement: Calendar screen widget test exists
The system SHALL have a widget test that verifies the calendar screen renders the month grid and day states.

#### Scenario: Calendar renders month grid
- **WHEN** the calendar screen is rendered
- **THEN** a grid of day cells SHALL be visible for the current month

#### Scenario: Day tap opens edit
- **WHEN** a day cell is tapped
- **THEN** a state-selection dialog or action SHALL appear

### Requirement: Settings profile form widget test exists
The system SHALL have a widget test that verifies the Settings > Profile form renders and accepts input.

#### Scenario: Profile form renders fields
- **WHEN** the Settings > Profile screen is rendered
- **THEN** the name field, bio field, and goal selector SHALL be present

#### Scenario: Form fields accept input
- **WHEN** the user types in the name field
- **THEN** the field SHALL update with the entered text
