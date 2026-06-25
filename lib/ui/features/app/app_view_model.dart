import 'package:flutter/material.dart';

import '../../../data/repositories/profile_repository.dart';
import '../../../models/profile.dart';

class AppViewModel extends ChangeNotifier {
  AppViewModel({required ProfileRepository profileRepository})
      : _profileRepository = profileRepository {
    _themeMode = _profileRepository.loadThemeMode();
    _locale = _profileRepository.loadLocale();
    _profile = _profileRepository.loadProfile();
  }

  final ProfileRepository _profileRepository;

  late ThemeMode _themeMode;
  late Locale _locale;
  late UserProfile _profile;
  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  UserProfile get profile => _profile;
  String currentRouteName = '/';

  void updateThemeMode(ThemeMode mode) {
    final updatedProfile = _mapProfileThemeColor(_profile, mode);
    final shouldSaveProfile = updatedProfile != _profile;
    _themeMode = mode;
    _profile = updatedProfile;
    notifyListeners();
    _profileRepository.saveThemeMode(mode);
    if (shouldSaveProfile) {
      _profileRepository.saveProfile(updatedProfile);
    }
  }

  void updateLocale(Locale? locale) {
    final nextLocale = locale ?? const Locale('en');
    _locale = nextLocale;
    notifyListeners();
    _profileRepository.saveLocale(nextLocale);
  }

  void updateProfile(UserProfile profile) {
    _profile = profile;
    notifyListeners();
    _profileRepository.saveProfile(profile);
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
}

const _dynamicAvatarLightColor = 0xFFFDF6EC;
const _dynamicAvatarDarkColor = 0xFF0F1A18;
