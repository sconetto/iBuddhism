import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../app/app_view_model.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required AppViewModel appViewModel,
  }) : _appViewModel = appViewModel {
    _name = _appViewModel.profile.name ?? '';
    _bio = _appViewModel.profile.bio ?? '';
    _selectedAvatarColor = _appViewModel.profile.avatarColorValue;
    _avatarPath = _appViewModel.profile.avatarPath;
    _dateOfBirth = _appViewModel.profile.dateOfBirth;
    _weeklyGoal = _appViewModel.profile.gongyoWeeklyGoal;
  }

  final AppViewModel _appViewModel;

  String _name = '';
  String _bio = '';
  int? _selectedAvatarColor;
  String? _avatarPath;
  String? _dateOfBirth;
  int _weeklyGoal = 5;

  String get name => _name;
  String get bio => _bio;
  int? get selectedAvatarColor => _selectedAvatarColor;
  String? get avatarPath => _avatarPath;
  String? get dateOfBirth => _dateOfBirth;
  int get weeklyGoal => _weeklyGoal;
  UserProfile get profile => _appViewModel.profile;
  Locale? get locale => _appViewModel.locale;

  void updateName(String value) {
    _name = value;
    _notifyProfileChanged();
  }

  void updateBio(String value) {
    _bio = value;
    _notifyProfileChanged();
  }

  void selectAvatarColor(int? colorValue) {
    _selectedAvatarColor = colorValue;
    notifyListeners();
    _notifyProfileChanged();
  }

  void setAvatarPath(String? path) {
    _avatarPath = path;
    notifyListeners();
    _notifyProfileChanged();
  }

  void setDateOfBirth(String? value) {
    _dateOfBirth = value;
    notifyListeners();
    _notifyProfileChanged();
  }

  void removeAvatar() {
    _avatarPath = null;
    notifyListeners();
    _notifyProfileChanged();
  }

  void updateWeeklyGoal(int value) {
    _weeklyGoal = value;
    notifyListeners();
    _notifyProfileChanged();
  }

  int? calculateAge(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
    final now = DateTime.now();
    var age = now.year - parsed.year;
    final hadBirthday = (now.month > parsed.month) ||
        (now.month == parsed.month && now.day >= parsed.day);
    if (!hadBirthday) age -= 1;
    return age < 0 ? null : age;
  }

  String formatDob(String? value, Locale? locale) {
    if (value == null || value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return '';
    final isEnglish = (locale?.languageCode ?? 'en') == 'en';
    if (isEnglish) {
      return '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    }
    return '${parsed.day.toString().padLeft(2, '0')}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.year}';
  }

  void _notifyProfileChanged() {
    _appViewModel.updateProfile(
      _appViewModel.profile.copyWith(
        name: _name.trim().isEmpty ? null : _name.trim(),
        bio: _bio.trim().isEmpty ? null : _bio.trim(),
        avatarColorValue: _selectedAvatarColor,
        avatarPath: _avatarPath,
        dateOfBirth: _dateOfBirth,
        gongyoWeeklyGoal: _weeklyGoal,
      ),
    );
  }
}
