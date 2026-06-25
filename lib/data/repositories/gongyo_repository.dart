import '../../models/gongyo_progress.dart';
import '../services/gongyo_progress_service.dart';

class GongyoRepository {
  GongyoRepository(this._service);

  final GongyoProgressService _service;

  Map<String, GongyoProgressStatus> getAll() => _service.getAll();
  Map<String, int> getMonthlyGoals() => _service.getMonthlyGoals();
  int? getMonthlyGoal(String monthKey) => _service.getMonthlyGoal(monthKey);
  Future<void> setStatus(String dateKey, GongyoProgressStatus status) =>
      _service.setStatus(dateKey, status);
  Future<void> setMonthlyGoal(String monthKey, int goal) =>
      _service.setMonthlyGoal(monthKey, goal);
}
