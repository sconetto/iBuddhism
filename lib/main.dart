import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/about_screen.dart';
import 'screens/gongyo_rhythmic_screen.dart';
import 'screens/home_screen.dart';
import 'screens/resources_list_screen.dart';
import 'screens/settings_screen.dart';
import 'models/profile.dart';
import 'theme/app_materials.dart';

const _themeModeKey = 'theme_mode';
const _localeKey = 'locale';
const _userNameKey = 'user_name';
const _profileKey = 'user_profile';
const _dynamicAvatarLightColor = 0xFFFDF6EC;
const _dynamicAvatarDarkColor = 0xFF0F1A18;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeMode = _loadThemeMode(prefs);
  final locale = _loadLocale(prefs);
  final profile = await _loadProfile(prefs);
  runApp(
    IBuddhismApp(
      initialThemeMode: themeMode,
      initialLocale: locale,
      initialProfile: profile,
    ),
  );
}

ThemeMode _loadThemeMode(SharedPreferences prefs) {
  final value = prefs.getString(_themeModeKey);
  switch (value) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
      return ThemeMode.system;
  }
  return ThemeMode.system;
}

Locale _loadLocale(SharedPreferences prefs) {
  final value = prefs.getString(_localeKey);
  if (value == null || value.isEmpty) {
    return const Locale('en');
  }
  final parts = value.split(RegExp('[-_]'));
  if (parts.length == 1) {
    return Locale(parts[0]);
  }
  return Locale(parts[0], parts[1]);
}

Future<UserProfile> _loadProfile(SharedPreferences prefs) async {
  final storedProfile = prefs.getString(_profileKey);
  if (storedProfile != null && storedProfile.trim().isNotEmpty) {
    try {
      final json = jsonDecode(storedProfile) as Map<String, dynamic>;
      return UserProfile.fromJson(json);
    } catch (_) {}
  }

  final storedName = prefs.getString(_userNameKey);
  if (storedName != null && storedName.trim().isNotEmpty) {
    return UserProfile(
      name: storedName.trim(),
      bio: null,
      avatarColorValue: Colors.deepPurple.toARGB32(),
      avatarPath: null,
      dateOfBirth: null,
      gongyoWeeklyGoal: 5,
    );
  }

  return UserProfile(
    name: 'User',
    bio: null,
    avatarColorValue: Colors.deepPurple.toARGB32(),
    avatarPath: null,
    dateOfBirth: null,
    gongyoWeeklyGoal: 5,
  );
}

class IBuddhismApp extends StatefulWidget {
  const IBuddhismApp({
    super.key,
    required this.initialThemeMode,
    required this.initialLocale,
    required this.initialProfile,
  });

  final ThemeMode initialThemeMode;
  final Locale initialLocale;
  final UserProfile initialProfile;

  @override
  State<IBuddhismApp> createState() => _IBuddhismAppState();
}

class _IBuddhismAppState extends State<IBuddhismApp> {
  late ThemeMode _themeMode;
  late Locale _locale;
  late UserProfile _profile;
  String _currentRouteName = HomeScreen.routeName;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
    _locale = widget.initialLocale;
    _profile = widget.initialProfile;
  }

  void _updateThemeMode(ThemeMode mode) {
    final updatedProfile = _mapProfileThemeColor(_profile, mode);
    final shouldSaveProfile = updatedProfile != _profile;
    setState(() {
      _themeMode = mode;
      _profile = updatedProfile;
    });
    _saveThemeMode(mode);
    if (shouldSaveProfile) {
      _saveProfile(updatedProfile);
    }
  }

  void _updateLocale(Locale? locale) {
    final nextLocale = locale ?? const Locale('en');
    setState(() {
      _locale = nextLocale;
    });
    _saveLocale(nextLocale);
  }

  void _updateProfile(UserProfile profile) {
    setState(() {
      _profile = profile;
    });
    _saveProfile(profile);
  }

  UserProfile _mapProfileThemeColor(UserProfile profile, ThemeMode mode) {
    if (mode == ThemeMode.system) {
      return profile;
    }
    final current = profile.avatarColorValue;
    if (current == null) {
      return profile;
    }
    if (mode == ThemeMode.dark && current == _dynamicAvatarDarkColor) {
      return profile.copyWith(avatarColorValue: _dynamicAvatarLightColor);
    }
    if (mode == ThemeMode.light && current == _dynamicAvatarLightColor) {
      return profile.copyWith(avatarColorValue: _dynamicAvatarDarkColor);
    }
    return profile;
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeModeKey, value);
  }

  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.toLanguageTag());
  }

  Future<void> _saveUserName(String? name) async {
    final prefs = await SharedPreferences.getInstance();
    if (name == null || name.trim().isEmpty) {
      await prefs.remove(_userNameKey);
      return;
    }
    await prefs.setString(_userNameKey, name.trim());
  }

  Future<void> _saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    if (profile.name != null) {
      await _saveUserName(profile.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    const lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0F1A18),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFDED9E2),
      onSecondary: Color(0xFF0F1A18),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFCF4EE),
      onSurface: Color(0xFF0F1A18),
    );

    const darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFCF4EE),
      onPrimary: Color(0xFF0F1A18),
      secondary: Color(0xFFDED9E2),
      onSecondary: Color(0xFF0F1A18),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: Color(0xFF0F1A18),
      onSurface: Color(0xFFFCF4EE),
    );

    const baseTextTheme = TextTheme(
      headlineSmall: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.6,
      ),
    );

    final theme = ThemeData(
      colorScheme: lightScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      useMaterial3: true,
      textTheme: baseTextTheme.apply(
        bodyColor: lightScheme.onSurface,
        displayColor: lightScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF0F1A18),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      extensions: const [
        defaultGlassMaterial,
      ],
    );

    final darkTheme = ThemeData(
      colorScheme: darkScheme,
      scaffoldBackgroundColor: const Color(0xFF0F1A18),
      useMaterial3: true,
      textTheme: baseTextTheme.apply(
        bodyColor: darkScheme.onSurface,
        displayColor: darkScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFF0F1A18),
        foregroundColor: Color(0xFFFCF4EE),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      extensions: const [
        defaultGlassMaterial,
      ],
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? HomeScreen.routeName;
    if (name == SettingsScreen.routeName || name == AboutScreen.routeName) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => _buildPage(name),
      );
    }

    final fromIndex = _tabIndex(_currentRouteName);
    final toIndex = _tabIndex(name);
    _currentRouteName = name;

    final isForward = toIndex >= fromIndex;
    final beginOffset = toIndex == fromIndex
        ? const Offset(0, 0)
        : (isForward ? const Offset(-0.12, 0) : const Offset(0.12, 0));

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => _buildPage(name),
      transitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final slide = Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }

  int _tabIndex(String? routeName) {
    switch (routeName) {
      case HomeScreen.routeName:
        return 0;
      case GongyoRhythmicScreen.routeName:
        return 1;
      case ResourcesListScreen.routeName:
        return 2;
    }
    return 0;
  }

  Widget _buildPage(String routeName) {
    switch (routeName) {
      case HomeScreen.routeName:
        return HomeScreen(
          themeMode: _themeMode,
          onThemeModeChanged: _updateThemeMode,
          locale: _locale,
          onLocaleChanged: _updateLocale,
          profile: _profile,
        );
      case GongyoRhythmicScreen.routeName:
        return GongyoRhythmicScreen(profile: _profile);
      case ResourcesListScreen.routeName:
        return const ResourcesListScreen();
      case AboutScreen.routeName:
        return const AboutScreen();
      case SettingsScreen.routeName:
        return SettingsScreen(
          locale: _locale,
          onLocaleChanged: _updateLocale,
          profile: _profile,
          onProfileChanged: _updateProfile,
        );
    }
    return HomeScreen(
      themeMode: _themeMode,
      onThemeModeChanged: _updateThemeMode,
      locale: _locale,
      onLocaleChanged: _updateLocale,
      profile: _profile,
    );
  }
}
