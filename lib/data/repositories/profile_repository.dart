import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  ProfileRepository(this._service);

  final ProfileService _service;

  ThemeMode loadThemeMode() => _service.loadThemeMode();
  Future<void> saveThemeMode(ThemeMode mode) => _service.saveThemeMode(mode);

  Locale loadLocale() => _service.loadLocale();
  Future<void> saveLocale(Locale locale) => _service.saveLocale(locale);

  UserProfile loadProfile() => _service.loadProfile();
  Future<void> saveProfile(UserProfile profile) =>
      _service.saveProfile(profile);
}
