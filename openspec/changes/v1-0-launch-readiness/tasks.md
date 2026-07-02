## 1. CJK Font Support

- [ ] 1.1 Download `NotoSansSC-Regular.ttf` and place in `assets/fonts/`
- [ ] 1.2 Declare font in `pubspec.yaml` under `fonts:` section
- [ ] 1.3 Verify Gongyo screen renders Chinese characters (南無妙法蓮華經) without tofu boxes
- [ ] 1.4 Run `flutter analyze` to confirm no regressions

## 2. Gongyo Progress Indicator

- [ ] 2.1 Add `totalLines` getter to `GongyoViewModel` that sums verses from selected chapters
- [ ] 2.2 Add `currentProgress` label to Gongyo screen (e.g., "12 / 45")
- [ ] 2.3 Update progress display on line advance and chapter toggle
- [ ] 2.4 Run `flutter analyze` to confirm no regressions

## 3. Gongyo Stop Confirmation

- [ ] 3.1 Add `AlertDialog` with Confirm/Cancel to stop action when recitation is active
- [ ] 3.2 Ensure idle state stop bypasses the dialog
- [ ] 3.3 Run `flutter analyze` to confirm no regressions

## 4. GongyoViewModel Unit Tests

- [ ] 4.1 Create `test/viewmodels/gongyo_viewmodel_test.dart`
- [ ] 4.2 Test chapter toggle (on, off, last-chapter guard)
- [ ] 4.3 Test start/stop/pause/resume lifecycle
- [ ] 4.4 Test line advance and `totalLines` computation
- [ ] 4.5 Test loop modes (none, chapter, all)
- [ ] 4.6 Run `flutter test` to confirm all tests pass

## 5. Widget Tests

- [ ] 5.1 Create `test/widgets/gongyo_controls_test.dart` — verify play/pause/stop buttons render and respond
- [ ] 5.2 Create `test/widgets/calendar_screen_test.dart` — verify month grid renders and day tap works
- [ ] 5.3 Create `test/widgets/settings_profile_test.dart` — verify profile form fields render and accept input
- [ ] 5.4 Run `flutter test` to confirm all widget tests pass

## 6. Dependency Updates

- [ ] 6.1 Run `flutter pub upgrade liquid_glass_widgets` and verify compatibility
- [ ] 6.2 Run `flutter pub upgrade image_picker` and verify compatibility
- [ ] 6.3 Run `flutter analyze` and `flutter test` to confirm no regressions
