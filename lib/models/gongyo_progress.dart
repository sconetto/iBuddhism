class GongyoProgressEntry {
  const GongyoProgressEntry({required this.dateKey, required this.status});

  final String dateKey;
  final GongyoProgressStatus status;
}

enum GongyoProgressStatus {
  none,
  started,
  completed,
}

GongyoProgressStatus gongyoStatusFromString(String? value) {
  switch (value) {
    case 'started':
      return GongyoProgressStatus.started;
    case 'completed':
      return GongyoProgressStatus.completed;
  }
  return GongyoProgressStatus.none;
}

String gongyoStatusToString(GongyoProgressStatus status) {
  switch (status) {
    case GongyoProgressStatus.started:
      return 'started';
    case GongyoProgressStatus.completed:
      return 'completed';
    case GongyoProgressStatus.none:
      return 'none';
  }
}
