import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/gongyo_progress.dart';

class GongyoProgressService {
  GongyoProgressService(this._prefs);

  final SharedPreferences _prefs;

  static const _storageKey = 'gongyo_progress';

  Map<String, dynamic>? _cached;

  Map<String, dynamic> _readAll() {
    if (_cached != null) return _cached!;
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      _cached = {};
      return _cached!;
    }
    _cached = jsonDecode(raw) as Map<String, dynamic>;
    return _cached!;
  }

  Map<String, GongyoProgressStatus> getAll() {
    final data = _readAll();
    final progressJson = data['progress'] as Map<String, dynamic>?;
    if (progressJson == null) {
      return data.map(
        (key, value) => MapEntry(key, gongyoStatusFromString(value as String?)),
      );
    }
    return progressJson.map(
      (key, value) => MapEntry(key, gongyoStatusFromString(value as String?)),
    );
  }

  Map<String, int> getMonthlyGoals() {
    final data = _readAll();
    final goalsJson = data['monthlyGoals'] as Map<String, dynamic>?;
    if (goalsJson == null) return {};
    return goalsJson.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
  }

  int? getMonthlyGoal(String monthKey) {
    return getMonthlyGoals()[monthKey];
  }

  Future<void> setStatus(String dateKey, GongyoProgressStatus status) async {
    final data = _readAll();
    final progress = Map<String, dynamic>.from(
      data['progress'] as Map<String, dynamic>? ?? {},
    );
    progress[dateKey] = gongyoStatusToString(status);
    data['progress'] = progress;
    _cached = data;
    await _prefs.setString(_storageKey, jsonEncode(data));
  }

  Future<void> setMonthlyGoal(String monthKey, int goal) async {
    final data = _readAll();
    final goals = Map<String, dynamic>.from(
      data['monthlyGoals'] as Map<String, dynamic>? ?? {},
    );
    goals[monthKey] = goal;
    data['monthlyGoals'] = goals;
    _cached = data;
    await _prefs.setString(_storageKey, jsonEncode(data));
  }
}
