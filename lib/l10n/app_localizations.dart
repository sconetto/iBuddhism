import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'iBuddhism'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navGongyo.
  ///
  /// In en, this message translates to:
  /// **'Gongyo'**
  String get navGongyo;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navAbout;

  /// No description provided for @homeGreetingFormat.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}, {timeOfDay}!'**
  String homeGreetingFormat(Object name, Object timeOfDay);

  /// No description provided for @homeGreetingNoName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {timeOfDay}!'**
  String homeGreetingNoName(Object timeOfDay);

  /// No description provided for @homeGreetingLineOneWithName.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String homeGreetingLineOneWithName(Object name);

  /// No description provided for @homeGreetingLineOneNoName.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get homeGreetingLineOneNoName;

  /// No description provided for @homeTimeDay.
  ///
  /// In en, this message translates to:
  /// **'good morning'**
  String get homeTimeDay;

  /// No description provided for @homeTimeAfternoon.
  ///
  /// In en, this message translates to:
  /// **'good afternoon'**
  String get homeTimeAfternoon;

  /// No description provided for @homeTimeNight.
  ///
  /// In en, this message translates to:
  /// **'good evening'**
  String get homeTimeNight;

  /// No description provided for @homeSubhead.
  ///
  /// In en, this message translates to:
  /// **'Access study and reflection texts to support your journey.'**
  String get homeSubhead;

  /// No description provided for @homeCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Gongyo'**
  String get homeCalendarTitle;

  /// No description provided for @homeCalendarHeader.
  ///
  /// In en, this message translates to:
  /// **'Gongyo Calendar'**
  String get homeCalendarHeader;

  /// No description provided for @homeCalendarProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get homeCalendarProgressTitle;

  /// No description provided for @homeCalendarToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get homeCalendarToday;

  /// No description provided for @homeCalendarLegendEmpty.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get homeCalendarLegendEmpty;

  /// No description provided for @homeCalendarLegendStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get homeCalendarLegendStarted;

  /// No description provided for @homeCalendarLegendCompleted.
  ///
  /// In en, this message translates to:
  /// **'Recited'**
  String get homeCalendarLegendCompleted;

  /// No description provided for @homeCalendarProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} days recited'**
  String homeCalendarProgress(Object completed, Object total);

  /// No description provided for @homeLocalContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Local content'**
  String get homeLocalContentTitle;

  /// No description provided for @homeLocalContentBody.
  ///
  /// In en, this message translates to:
  /// **'All content is saved on the device for offline reading.'**
  String get homeLocalContentBody;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(Object name);

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @gongyoTitle.
  ///
  /// In en, this message translates to:
  /// **'Gongyo'**
  String get gongyoTitle;

  /// No description provided for @gongyoSelectChaptersTitle.
  ///
  /// In en, this message translates to:
  /// **'Select chapters to recite.'**
  String get gongyoSelectChaptersTitle;

  /// No description provided for @gongyoSelectChaptersHint.
  ///
  /// In en, this message translates to:
  /// **'At least one chapter must remain selected.'**
  String get gongyoSelectChaptersHint;

  /// No description provided for @gongyoHoben.
  ///
  /// In en, this message translates to:
  /// **'Hoben-pon'**
  String get gongyoHoben;

  /// No description provided for @gongyoJuryo.
  ///
  /// In en, this message translates to:
  /// **'Juryo-hon'**
  String get gongyoJuryo;

  /// No description provided for @gongyoTempoLabel.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get gongyoTempoLabel;

  /// No description provided for @gongyoTempoHelp.
  ///
  /// In en, this message translates to:
  /// **'Adjust how quickly the text advances.'**
  String get gongyoTempoHelp;

  /// No description provided for @gongyoStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get gongyoStart;

  /// No description provided for @gongyoPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get gongyoPause;

  /// No description provided for @gongyoResume.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get gongyoResume;

  /// No description provided for @gongyoRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get gongyoRestart;

  /// No description provided for @gongyoStop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get gongyoStop;

  /// No description provided for @gongyoExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get gongyoExit;

  /// No description provided for @gongyoSectionDaimokuStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Daimoku'**
  String get gongyoSectionDaimokuStartTitle;

  /// No description provided for @gongyoSectionDaimokuStartDescription.
  ///
  /// In en, this message translates to:
  /// **'Recite Nam-myoho-renge-kyo three times.'**
  String get gongyoSectionDaimokuStartDescription;

  /// No description provided for @gongyoSectionHobenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hoben-pon (Chapter 2)'**
  String get gongyoSectionHobenTitle;

  /// No description provided for @gongyoSectionHobenDescription.
  ///
  /// In en, this message translates to:
  /// **'Until the final “ma ku kyo to”.'**
  String get gongyoSectionHobenDescription;

  /// No description provided for @gongyoSectionJuryoTitle.
  ///
  /// In en, this message translates to:
  /// **'Juryo-hon (Chapter 16)'**
  String get gongyoSectionJuryoTitle;

  /// No description provided for @gongyoSectionJuryoDescription.
  ///
  /// In en, this message translates to:
  /// **'The chapter on the “Lifespan of the Tathagata”.'**
  String get gongyoSectionJuryoDescription;

  /// No description provided for @gongyoSectionDaimokuEndTitle.
  ///
  /// In en, this message translates to:
  /// **'Daimoku (Closing)'**
  String get gongyoSectionDaimokuEndTitle;

  /// No description provided for @gongyoSectionDaimokuEndDescription.
  ///
  /// In en, this message translates to:
  /// **'Continue reciting Nam-myoho-renge-kyo with focus on the Gohonzon.'**
  String get gongyoSectionDaimokuEndDescription;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @resourceSource.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String resourceSource(Object source);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese 🇧🇷'**
  String get settingsLanguagePortuguese;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English 🇺🇸'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'iBuddhism is a minimalist companion for Gongyo and study.'**
  String get settingsAboutBody;

  /// No description provided for @settingsAction.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsAction;

  /// No description provided for @profileAction.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileAction;

  /// No description provided for @settingsProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get settingsProfileTitle;

  /// No description provided for @settingsProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsProfileNameLabel;

  /// No description provided for @settingsProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get settingsProfileNameHint;

  /// No description provided for @settingsProfileNameDescription.
  ///
  /// In en, this message translates to:
  /// **'This name is stored locally on your device.'**
  String get settingsProfileNameDescription;

  /// No description provided for @settingsProfileBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get settingsProfileBioLabel;

  /// No description provided for @settingsProfileBioHint.
  ///
  /// In en, this message translates to:
  /// **'Share a short note'**
  String get settingsProfileBioHint;

  /// No description provided for @settingsProfileAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile color'**
  String get settingsProfileAvatarTitle;

  /// No description provided for @settingsProfileAvatarCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get settingsProfileAvatarCamera;

  /// No description provided for @settingsProfileAvatarGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get settingsProfileAvatarGallery;

  /// No description provided for @settingsProfileAvatarRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove profile photo'**
  String get settingsProfileAvatarRemove;

  /// No description provided for @settingsProfileDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get settingsProfileDobLabel;

  /// No description provided for @settingsProfileDobPick.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get settingsProfileDobPick;

  /// No description provided for @settingsProfileAge.
  ///
  /// In en, this message translates to:
  /// **'{age} years'**
  String settingsProfileAge(Object age);

  /// No description provided for @settingsProfileWeeklyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal'**
  String get settingsProfileWeeklyGoalLabel;

  /// No description provided for @settingsGongyoGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Gongyo goal'**
  String get settingsGongyoGoalTitle;

  /// No description provided for @settingsProfileWeeklyGoalValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} time/week} other{{count} times/week}}'**
  String settingsProfileWeeklyGoalValue(num count);

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutHeadline.
  ///
  /// In en, this message translates to:
  /// **'iBuddhism'**
  String get aboutHeadline;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'iBuddhism is a minimalist companion for Gongyo and study, designed to support daily practice with clarity and presence.'**
  String get aboutBody;

  /// No description provided for @aboutAuthorTitle.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get aboutAuthorTitle;

  /// No description provided for @aboutAuthorBody.
  ///
  /// In en, this message translates to:
  /// **'Created by João Pedro Sconetto and Mariana de Souza Mendes.\nMade with ♥️ and ☕.'**
  String get aboutAuthorBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
