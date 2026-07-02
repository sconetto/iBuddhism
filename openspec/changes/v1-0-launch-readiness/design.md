## Context

iBuddhism is a single-user offline Flutter app. The current MVP has working Gongyo recitation, calendar tracking, and settings — but several gaps prevent a polished v1.0. There is no font bundling for CJK text, no recitation progress feedback, no stop confirmation, no automated tests, and outdated dependencies.

The app uses `shared_preferences` for persistence, `liquid_glass_widgets` for the bottom nav and controls, and ARB-based i18n (EN/PT-BR). The Gongyo screen uses a `ViewModel` pattern with `Timer`-based line advancement.

## Goals / Non-Goals

**Goals:**
- Ensure Chinese characters render on all platforms without relying on system fonts.
- Show non-intrusive recitation progress (current line / total lines) during Gongyo.
- Prevent accidental recitation stop via confirmation dialog.
- Unit-test all GongyoViewModel logic deterministically.
- Widget-test the critical user journeys (Gongyo playback, calendar navigation, Settings profile form).
- Bump `liquid_glass_widgets` and `image_picker` to latest compatible versions.
- Set up CI/CD pipeline that validates every push and PR.

**Non-Goals:**
- No onboarding tutorial (separate future change).
- No daily-reminder notifications (separate future change).
- No data backup/restore (separate future change).
- No refactoring of the existing ViewModel architecture — only additive changes.

## Decisions

### 1. Font Strategy: Bundle NotoSansSC `.ttf` via pubspec assets

- **Context**: Gongyo screen currently sets `fontFamily: 'NotoSansSC'` but the font is not declared in `pubspec.yaml` or present in the assets directory. On devices without the system font, Chinese text renders as boxes.
- **Decision**: Download the NotoSansSC `.ttf` (static, regular weight) and declare it in `pubspec.yaml` under `fonts:`.
- **Rationale**: Bundling guarantees consistent rendering across all platforms. System CJK fallback varies per OS — iOS/macOS use PingFang, Android uses Noto Sans CJK — leading to inconsistent weight and spacing. Bundling a single `.ttf` (~5 MB for SC subset) is the standard Flutter approach.
- **Alternative considered**: Using `GoogleFonts` package — rejected because it requires runtime network fetch and breaks offline use.

### 2. Progress Indicator: Inline label in Gongyo scroll area

- **Context**: Gongyo screen displays Chinese text in a scrollable area with line-by-line highlighting. There's no concept of "total lines" computed anywhere.
- **Decision**: Compute total visible lines statically from the selected chapters on start, and track current highlighted index. Display a compact label like "12 / 45" at the top-right of the scroll area.
- **Rationale**: Minimal UI change, no new widgets needed. The ViewModel already tracks `currentLineIndex`; adding a `totalLines` getter is straightforward.
- **Alternative considered**: Bottom snackbar — rejected because it fights with the control bar for attention.

### 3. Stop Confirmation: Simple `AlertDialog`

- **Context**: The stop button currently resets recitation state immediately with no prompt.
- **Decision**: Wrap the stop action in an `AlertDialog` with "Confirm" / "Cancel". Only shown when recitation is actively in progress (not on idle screen).
- **Rationale**: Follows Material 3 dialog patterns already used elsewhere in the app. Minimal code change, high UX value.

### 4. Tests: `flutter_test` with `shared_preferences` test injection

- **Context**: No tests exist. `GongyoViewModel` uses `shared_preferences` for persisting chapter-toggled state.
- **Decision**: Use `SharedPreferences.setMockInitialValues({})` in test setup. Test GongyoViewModel in isolation (constructor, toggle, start, advance, pause, stop, reset). Widget tests via `WidgetTester` pumpWidget.
- **Rationale**: `shared_preferences` is the only external dependency of the ViewModel. Mock initial values are simple and well-documented. No need for a DI framework at this scale.

### 6. CI/CD: GitHub Actions with Flutter CI

- **Context**: The pre-commit hooks (format, analyze, test) only run locally. GitHub has no CI to catch regressions on push or PR.
- **Decision**: Single GitHub Actions workflow with two jobs — `check` (analyze + test on every push/PR) and `build` (on tag push).
- **Rationale**: GitHub Actions is free for public repos, natively integrated, and has official Flutter setup actions. Two-job separation keeps fast checks from waiting on builds.
- **Alternative considered**: Codemagic — more powerful but overkill for this project's size.

### 5. Dependency Updates: Semver-compatible bumps

- **Context**: `pubspec.yaml` lists `liquid_glass_widgets: ^1.0.0` and `image_picker: ^0.8.9`.
- **Decision**: Run `flutter pub upgrade --major-versions` for those packages individually and test compatibility.
- **Rationale**: Keeping current within the existing resolution is lower risk than a full `pub upgrade`.

## Risks / Trade-offs

- **[CI runtime]**: Flutter CI takes 3-5 minutes per run, which can slow down PR iteration.
  - **Mitigation**: The `check` job is fast (no build artifacts); slow builds only trigger on tags.
- **[Font size]**: NotoSansSC `.ttf` is ~5 MB, increasing app download size. For a utility app this is acceptable, but worth noting for users on limited data plans.
  - **Mitigation**: Use `NotoSansSC` static weight (not variable) and subset to CJK ideographs only.
- **[Gongyo totalLines]**: The current line highlighting logic in `GongyoViewModel` indexes into a flat list of verses. If the line-count formula changes, the progress calculation must stay in sync.
  - **Mitigation**: Unit tests will catch mismatches immediately.
- **[shared_preferences mocking]**: `SharedPreferences.setMockInitialValues` is a static global — tests cannot run in parallel if they set different initial values.
  - **Mitigation**: We have no parallel test execution today. Document this as a known limitation for future refactoring.
- **[Dependency bumps may break]**: Newer versions of `liquid_glass_widgets` or `image_picker` could introduce breaking API changes.
  - **Mitigation**: Run full `flutter test` and `flutter analyze` after each bump.
