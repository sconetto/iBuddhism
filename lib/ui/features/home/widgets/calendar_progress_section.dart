import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

class CalendarProgressSection extends StatelessWidget {
  const CalendarProgressSection({
    super.key,
    required this.goalDays,
    required this.completedDays,
  });

  final int goalDays;
  final int completedDays;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final safeGoal = goalDays.clamp(1, 9999);
    final progressRatio = completedDays / safeGoal;
    final baseProgress = progressRatio.clamp(0.0, 1.0);
    final extraProgress = (progressRatio - 1.0).clamp(0.0, 1.0);
    final percentLabel = (progressRatio * 100).clamp(0.0, 999.0).round();
    const opaqueBaseColor = Color.fromARGB(209, 255, 255, 255);
    const opaqueBaseColorDark = Color(0xFF0F1A18);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = !isDark
        ? opaqueBaseColorDark.withValues(alpha: 0.2)
        : opaqueBaseColor.withValues(alpha: 0.2);
    const progressBaseColor = Color(0xFF95D6A4);
    const progressExtraColor = Color(0xFFFFCC33);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeCalendarProgressTitle,
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: baseProgress,
                      backgroundColor: backgroundColor,
                      color: progressBaseColor,
                      strokeWidth: 6,
                    ),
                    if (extraProgress > 0)
                      CircularProgressIndicator(
                        value: extraProgress,
                        backgroundColor: Colors.transparent,
                        color: progressExtraColor,
                        strokeWidth: 6,
                      ),
                    SizedBox(
                      width: 56,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            '$percentLabel%',
                            textAlign: TextAlign.center,
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 9,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                l10n.homeCalendarProgress(completedDays, goalDays),
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
