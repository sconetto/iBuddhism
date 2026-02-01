import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/gongyo_progress.dart';

class GongyoProgressStore {
  GongyoProgressStore(this._prefs);

  final SharedPreferences _prefs;

  static const _storageKey = 'gongyo_progress';

  static Future<GongyoProgressStore> load() async {
    final prefs = await SharedPreferences.getInstance();
    return GongyoProgressStore(prefs);
  }

  Map<String, GongyoProgressStatus> getAll() {
    return _readProgress();
  }

  Map<String, int> getMonthlyGoals() {
    return _readMonthlyGoals();
  }

  int? getMonthlyGoal(String monthKey) {
    return _readMonthlyGoals()[monthKey];
  }

  Future<void> setMonthlyGoal(String monthKey, int weeklyGoal) async {
    final progress = _readProgress();
    final monthlyGoals = _readMonthlyGoals();
    monthlyGoals[monthKey] = weeklyGoal;
    await _writeAll(progress: progress, monthlyGoals: monthlyGoals);
  }

  Future<void> setStatus(String dateKey, GongyoProgressStatus status) async {
    final progress = _readProgress();
    final monthlyGoals = _readMonthlyGoals();
    progress[dateKey] = status;
    await _writeAll(progress: progress, monthlyGoals: monthlyGoals);
  }

  Map<String, GongyoProgressStatus> _readProgress() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final progressJson = decoded['progress'] as Map<String, dynamic>?;
    if (progressJson != null) {
      return progressJson.map(
        (key, value) => MapEntry(
          key,
          gongyoStatusFromString(value as String?),
        ),
      );
    }
    return decoded.map(
      (key, value) => MapEntry(
        key,
        gongyoStatusFromString(value as String?),
      ),
    );
  }

  Map<String, int> _readMonthlyGoals() {
    final raw = _prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return {};
    }
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final goalsJson = decoded['monthlyGoals'] as Map<String, dynamic>?;
    if (goalsJson == null) {
      return {};
    }
    return goalsJson.map(
      (key, value) => MapEntry(key, (value as num).toInt()),
    );
  }

  Future<void> _writeAll({
    required Map<String, GongyoProgressStatus> progress,
    required Map<String, int> monthlyGoals,
  }) async {
    final encoded = jsonEncode({
      'progress': progress
          .map((key, value) => MapEntry(key, gongyoStatusToString(value))),
      'monthlyGoals': monthlyGoals,
    });
    await _prefs.setString(_storageKey, encoded);
  }
}
