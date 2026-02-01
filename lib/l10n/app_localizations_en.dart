// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'iBuddhism';

  @override
  String get navHome => 'Home';

  @override
  String get navGongyo => 'Gongyo';

  @override
  String get navLibrary => 'Library';

  @override
  String get navAbout => 'About';

  @override
  String homeGreetingFormat(Object name, Object timeOfDay) {
    return 'Hello, $name, $timeOfDay!';
  }

  @override
  String homeGreetingNoName(Object timeOfDay) {
    return 'Hello, $timeOfDay!';
  }

  @override
  String homeGreetingLineOneWithName(Object name) {
    return 'Hello, $name 👋';
  }

  @override
  String get homeGreetingLineOneNoName => 'Hello 👋';

  @override
  String get homeTimeDay => 'good morning';

  @override
  String get homeTimeAfternoon => 'good afternoon';

  @override
  String get homeTimeNight => 'good evening';

  @override
  String get homeSubhead =>
      'Access study and reflection texts to support your journey.';

  @override
  String get homeCalendarTitle => 'Gongyo';

  @override
  String get homeCalendarHeader => 'Gongyo Calendar';

  @override
  String get homeCalendarProgressTitle => 'Monthly Progress';

  @override
  String get homeCalendarToday => 'Today';

  @override
  String get homeCalendarLegendEmpty => 'Not started';

  @override
  String get homeCalendarLegendStarted => 'Started';

  @override
  String get homeCalendarLegendCompleted => 'Recited';

  @override
  String homeCalendarProgress(Object completed, Object total) {
    return '$completed/$total days recited';
  }

  @override
  String get homeLocalContentTitle => 'Local content';

  @override
  String get homeLocalContentBody =>
      'All content is saved on the device for offline reading.';

  @override
  String homeGreeting(Object name) {
    return 'Hello, $name';
  }

  @override
  String get themeAuto => 'Auto';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get gongyoTitle => 'Gongyo';

  @override
  String get gongyoSelectChaptersTitle => 'Select chapters to recite.';

  @override
  String get gongyoSelectChaptersHint =>
      'At least one chapter must remain selected.';

  @override
  String get gongyoHoben => 'Hoben-pon';

  @override
  String get gongyoJuryo => 'Juryo-hon';

  @override
  String get gongyoTempoLabel => 'Tempo';

  @override
  String get gongyoTempoHelp => 'Adjust how quickly the text advances.';

  @override
  String get gongyoStart => 'Start';

  @override
  String get gongyoPause => 'Pause';

  @override
  String get gongyoResume => 'Continue';

  @override
  String get gongyoRestart => 'Restart';

  @override
  String get gongyoStop => 'Stop';

  @override
  String get gongyoExit => 'Exit';

  @override
  String get gongyoSectionDaimokuStartTitle => 'Daimoku';

  @override
  String get gongyoSectionDaimokuStartDescription =>
      'Recite Nam-myoho-renge-kyo three times.';

  @override
  String get gongyoSectionHobenTitle => 'Hoben-pon (Chapter 2)';

  @override
  String get gongyoSectionHobenDescription => 'Until the final “ma ku kyo to”.';

  @override
  String get gongyoSectionJuryoTitle => 'Juryo-hon (Chapter 16)';

  @override
  String get gongyoSectionJuryoDescription =>
      'The chapter on the “Lifespan of the Tathagata”.';

  @override
  String get gongyoSectionDaimokuEndTitle => 'Daimoku (Closing)';

  @override
  String get gongyoSectionDaimokuEndDescription =>
      'Continue reciting Nam-myoho-renge-kyo with focus on the Gohonzon.';

  @override
  String get libraryTitle => 'Library';

  @override
  String resourceSource(Object source) {
    return 'Source: $source';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageTitle => 'Language';

  @override
  String get settingsLanguageDescription => 'Choose the app language.';

  @override
  String get settingsLanguagePortuguese => 'Portuguese 🇧🇷';

  @override
  String get settingsLanguageEnglish => 'English 🇺🇸';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsAboutBody =>
      'iBuddhism is a minimalist companion for Gongyo and study.';

  @override
  String get settingsAction => 'Settings';

  @override
  String get profileAction => 'Profile';

  @override
  String get settingsProfileTitle => 'Profile';

  @override
  String get settingsProfileNameLabel => 'Your name';

  @override
  String get settingsProfileNameHint => 'Enter your name';

  @override
  String get settingsProfileNameDescription =>
      'This name is stored locally on your device.';

  @override
  String get settingsProfileBioLabel => 'Bio';

  @override
  String get settingsProfileBioHint => 'Share a short note';

  @override
  String get settingsProfileAvatarTitle => 'Profile color';

  @override
  String get settingsProfileAvatarCamera => 'Camera';

  @override
  String get settingsProfileAvatarGallery => 'Gallery';

  @override
  String get settingsProfileAvatarRemove => 'Remove profile photo';

  @override
  String get settingsProfileDobLabel => 'Date of birth';

  @override
  String get settingsProfileDobPick => 'Select date';

  @override
  String settingsProfileAge(Object age) {
    return '$age years';
  }

  @override
  String get settingsProfileWeeklyGoalLabel => 'Weekly goal';

  @override
  String get settingsGongyoGoalTitle => 'Gongyo goal';

  @override
  String settingsProfileWeeklyGoalValue(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times/week',
      one: '$count time/week',
    );
    return '$_temp0';
  }

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutHeadline => 'iBuddhism';

  @override
  String get aboutBody =>
      'iBuddhism is a minimalist companion for Gongyo and study, designed to support daily practice with clarity and presence.';

  @override
  String get aboutAuthorTitle => 'Author';

  @override
  String get aboutAuthorBody =>
      'Created by João Pedro Sconetto and Mariana de Souza Mendes.\nMade with ♥️ and ☕.';
}
