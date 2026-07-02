## Why

iBuddhism has a functional MVP but is not ready for a public v1.0 launch. A codebase audit revealed several critical gaps — missing CJK font support for Gongyo text, no onboarding experience, inadequate test coverage, and rough user-experience edges — that must be resolved before the app is polished enough for a first release.

This change addresses all identified launch-blocking and high-priority improvements in a structured way, starting with the most critical issues.

## What Changes

- Embed or bundle a CJK-capable font (NotoSansSC) so Chinese characters in Gongyo render correctly on all devices.
- Add a gongyo recitation progress indicator (current line / total lines) while reading.
- Add confirmation dialog before stopping/abandoning a recitation in progress.
- Write unit tests for GongyoViewModel (chapter selection, loop logic, advance/stop/pause).
- Write widget tests for key screens (Gongyo controls, Calendar, Settings profile form).
- Update outdated dependencies (`liquid_glass_widgets`, `image_picker`).
- (Future change, scoped out here) Onboarding tutorial, daily reminders, backup/restore.

## Capabilities

### New Capabilities
- `cjk-font-support`: Bundle and register a CJK font so Gongyo Chinese characters render on all platforms without relying on system fonts.
- `gongyo-progress-indicator`: Show "Line X of Y" + section progress during Gongyo recitation.
- `gongyo-stop-confirmation`: Confirm before stopping a recitation to prevent accidental loss of progress.
- `test-coverage-gongyo-viewmodel`: Unit tests for GongyoViewModel logic (chapter toggle, interval, timer, loops, progress marking).
- `test-coverage-widgets`: Widget tests for critical UI surfaces (Gongyo controls, Calendar, Settings profile).
- `dependency-updates`: Bump outdated packages to latest compatible versions.

### Modified Capabilities
*(No existing specs are being modified — all capabilities are new.)*

## Impact

- **Fonts**: Requires either downloading NotoSansSC as a `.ttf` asset or switching to a system-wide CJK fallback stack (iOS/macOS/Android all ship CJK-capable fonts).
- **Gongyo screen**: GongyoViewModel needs a computed total-line-count and current position; UI needs a non-intrusive indicator.
- **Gongyo control bar**: Stop action needs a confirmation dialog path.
- **Tests**: New test files under `test/` covering ViewModel logic and widget rendering.
- **pubspec.yaml**: Version bumps for `liquid_glass_widgets`.
