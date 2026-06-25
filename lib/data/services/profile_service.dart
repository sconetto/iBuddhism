import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/profile.dart';

class ProfileService {
  ProfileService(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _userNameKey = 'user_name';
  static const _profileKey = 'user_profile';

  ThemeMode loadThemeMode() {
    final value = _prefs.getString(_themeModeKey);
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

  Future<void> saveThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_themeModeKey, value);
  }

  Locale loadLocale() {
    final value = _prefs.getString(_localeKey);
    if (value == null || value.isEmpty) {
      return const Locale('en');
    }
    final parts = value.split(RegExp('[-_]'));
    if (parts.length == 1) {
      return Locale(parts[0]);
    }
    return Locale(parts[0], parts[1]);
  }

  Future<void> saveLocale(Locale locale) async {
    await _prefs.setString(_localeKey, locale.toLanguageTag());
  }

  UserProfile loadProfile() {
    final storedProfile = _prefs.getString(_profileKey);
    if (storedProfile != null && storedProfile.trim().isNotEmpty) {
      try {
        final json = jsonDecode(storedProfile) as Map<String, dynamic>;
        return UserProfile.fromJson(json);
      } catch (_) {}
    }

    final storedName = _prefs.getString(_userNameKey);
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

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    if (profile.name != null) {
      await _prefs.setString(_userNameKey, profile.name!);
    }
  }
}
