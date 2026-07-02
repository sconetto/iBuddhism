## ADDED Requirements

### Requirement: CJK font is bundled and registered
The system SHALL bundle a CJK-capable font (NotoSansSC Regular) in the app assets and declare it in `pubspec.yaml` under `fonts:`.

#### Scenario: Font declared in pubspec
- **WHEN** the app is built
- **THEN** `pubspec.yaml` SHALL list `NotoSansSC` under `fonts:` with the correct asset path

#### Scenario: Font renders Chinese characters in Gongyo
- **WHEN** the Gongyo screen displays Chinese text (e.g., 南無妙法蓮華經)
- **THEN** each character SHALL render as the intended glyph, not as a missing-glyph box or tofu character

### Requirement: NotoSansSC.ttf is present in assets
The system SHALL include `NotoSansSC-Regular.ttf` in the project assets directory.

#### Scenario: Asset file exists
- **WHEN** inspecting the assets directory
- **THEN** `NotoSansSC-Regular.ttf` SHALL exist at the path declared in `pubspec.yaml`

### Requirement: Gongyo screen uses bundled font
The Gongyo screen SHALL reference the bundled NotoSansSC font family for Chinese text sections.

#### Scenario: Chinese text uses NotoSansSC
- **WHEN** the Gongyo screen renders Chinese verse lines
- **THEN** those lines SHALL use the `NotoSansSC` font family
