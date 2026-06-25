import 'package:flutter/material.dart';

import '../../../data/repositories/gongyo_repository.dart';
import '../../../models/gongyo_progress.dart';
import '../../../models/profile.dart';
import '../app/app_view_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required GongyoRepository gongyoRepository,
    required AppViewModel appViewModel,
  })  : _gongyoRepository = gongyoRepository,
        _appViewModel = appViewModel {
    _loadProgress();
  }

  final GongyoRepository _gongyoRepository;
  final AppViewModel _appViewModel;

  Map<String, GongyoProgressStatus> _progress = {};
  Map<String, int> _monthlyGoals = {};
  DateTime _displayMonth = DateTime.now();

  Map<String, GongyoProgressStatus> get progress => _progress;
  Map<String, int> get monthlyGoals => _monthlyGoals;
  DateTime get displayMonth => _displayMonth;
  UserProfile get profile => _appViewModel.profile;

  UserProfile get currentProfile => _appViewModel.profile;

  Future<void> _loadProgress() async {
    _progress = _gongyoRepository.getAll();
    _monthlyGoals = _gongyoRepository.getMonthlyGoals();
    notifyListeners();
    await _ensureMonthlyGoal(_displayMonth);
  }

  void changeMonth(int delta) {
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    notifyListeners();
    _ensureMonthlyGoal(_displayMonth);
  }

  void goToToday() {
    _displayMonth = DateTime.now();
    notifyListeners();
    _ensureMonthlyGoal(DateTime.now());
  }

  String monthKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}';
  }

  String dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _ensureMonthlyGoal(DateTime date) async {
    final key = monthKey(date);
    if (_monthlyGoals.containsKey(key)) return;
    await _gongyoRepository.setMonthlyGoal(
        key, _appViewModel.profile.gongyoWeeklyGoal);
    _monthlyGoals = Map.from(_gongyoRepository.getMonthlyGoals());
    notifyListeners();
  }

  Future<void> updateCurrentMonthGoal() async {
    final nowKey = monthKey(DateTime.now());
    final currentValue = _monthlyGoals[nowKey];
    if (currentValue == _appViewModel.profile.gongyoWeeklyGoal) return;
    await _gongyoRepository.setMonthlyGoal(
        nowKey, _appViewModel.profile.gongyoWeeklyGoal);
    _monthlyGoals = Map.from(_gongyoRepository.getMonthlyGoals());
    notifyListeners();
  }
}
