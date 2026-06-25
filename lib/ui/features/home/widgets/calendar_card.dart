import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../../../../models/gongyo_progress.dart';
import 'calendar_legend.dart';
import 'calendar_progress_section.dart';

Color _shadeColor(Color color, double factor) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color _tintColor(Color color, double amount) {
  return Color.lerp(color, Colors.white, amount) ?? color;
}

class CalendarCard extends StatelessWidget {
  const CalendarCard({
    super.key,
    required this.locale,
    required this.progress,
    required this.month,
    required this.weeklyGoal,
    required this.baseColor,
    required this.onPreviousMonth,
    required this.onToday,
    required this.onNextMonth,
  });

  final Locale? locale;
  final Map<String, GongyoProgressStatus> progress;
  final DateTime month;
  final int weeklyGoal;
  final Color baseColor;
  final VoidCallback onPreviousMonth;
  final VoidCallback onToday;
  final VoidCallback onNextMonth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthStart = DateTime(month.year, month.month, 1);
    final monthLabel =
        DateFormat('MMMM yyyy', locale?.toLanguageTag()).format(monthStart);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startOffset = monthStart.weekday % 7;
    final totalCells = ((startOffset + daysInMonth + 6) / 7).floor() * 7;
    final weeksInMonth = (daysInMonth / 7).ceil();
    final goalDays = weeklyGoal * weeksInMonth;

    Color statusColor(GongyoProgressStatus status) {
      if (isDark) {
        return switch (status) {
          GongyoProgressStatus.completed => _shadeColor(baseColor, 0.9),
          GongyoProgressStatus.started => _shadeColor(baseColor, 0.5),
          GongyoProgressStatus.none => _shadeColor(baseColor, 0.1),
        };
      }
      return switch (status) {
        GongyoProgressStatus.completed => _tintColor(baseColor, 0.4),
        GongyoProgressStatus.started => _tintColor(baseColor, 0.6),
        GongyoProgressStatus.none => _tintColor(baseColor, 0.85),
      };
    }

    String dateKey(DateTime date) {
      return '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    List<String> weekdayLabels() {
      final base = DateTime(2023, 1, 1);
      return List.generate(7, (index) {
        final day = base.add(Duration(days: index));
        return DateFormat('EEE', locale?.toLanguageTag())
            .format(day)
            .substring(0, 1)
            .toUpperCase();
      });
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeCalendarHeader,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      monthLabel,
                      style: textTheme.headlineSmall?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                onPressed: onToday,
                icon: const Icon(Icons.today),
                tooltip: l10n.homeCalendarToday,
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in weekdayLabels())
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: textTheme.bodySmall,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final dayNumber = index - startOffset + 1;
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }
              final date = DateTime(month.year, month.month, dayNumber);
              final status =
                  progress[dateKey(date)] ?? GongyoProgressStatus.none;
              final dayColor = statusColor(status);
              final gradientColors = status == GongyoProgressStatus.none
                  ? null
                  : [
                      baseColor,
                      isDark
                          ? (status == GongyoProgressStatus.started
                              ? _shadeColor(baseColor, 0.5)
                              : _shadeColor(baseColor, 0.9))
                          : (status == GongyoProgressStatus.started
                              ? _tintColor(baseColor, 0.6)
                              : _tintColor(baseColor, 0.4)),
                    ];
              final gradient = gradientColors == null
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    );
              final textBackground = gradientColors == null
                  ? dayColor
                  : (Color.lerp(gradientColors[0], gradientColors[1], 0.5) ??
                      dayColor);
              final textColor = textBackground.computeLuminance() > 0.6
                  ? Colors.black
                  : Colors.white;

              return Container(
                decoration: BoxDecoration(
                  color: gradient == null ? dayColor : null,
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                  border: status == GongyoProgressStatus.none
                      ? Border.all(
                          color: isDark
                              ? _shadeColor(baseColor, 0.1)
                              : _tintColor(baseColor, 0.75),
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$dayNumber',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          CalendarLegend(
            baseColor: baseColor,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          CalendarProgressSection(
            goalDays: goalDays,
            completedDays: progress.entries.where((entry) {
              return entry.key.startsWith(
                    '${month.year.toString().padLeft(4, '0')}-'
                    '${month.month.toString().padLeft(2, '0')}',
                  ) &&
                  entry.value == GongyoProgressStatus.completed;
            }).length,
          ),
        ],
      ),
    );
  }
}
