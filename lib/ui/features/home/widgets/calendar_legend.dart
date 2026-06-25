import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

Color _shadeColor(Color color, double factor) {
  final hsl = HSLColor.fromColor(color);
  final lightness = (hsl.lightness * factor).clamp(0.0, 1.0);
  return hsl.withLightness(lightness).toColor();
}

Color _tintColor(Color color, double amount) {
  return Color.lerp(color, Colors.white, amount) ?? color;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadowColor = (isDark ? Colors.white : Colors.black).withValues(
      alpha: isDark ? 0.2 : 0.12,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class CalendarLegend extends StatelessWidget {
  const CalendarLegend({
    super.key,
    required this.baseColor,
    required this.isDark,
  });

  final Color baseColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emptyColor =
        isDark ? _shadeColor(baseColor, 0.1) : _tintColor(baseColor, 0.85);
    final startedColor =
        isDark ? _shadeColor(baseColor, 0.5) : _tintColor(baseColor, 0.6);
    final completedColor =
        isDark ? _shadeColor(baseColor, 0.9) : _tintColor(baseColor, 0.4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Align(
              alignment: Alignment.center,
              child: _LegendDot(
                color: emptyColor,
                label: l10n.homeCalendarLegendEmpty,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Align(
              alignment: Alignment.center,
              child: _LegendDot(
                color: startedColor,
                label: l10n.homeCalendarLegendStarted,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Align(
              alignment: Alignment.center,
              child: _LegendDot(
                color: completedColor,
                label: l10n.homeCalendarLegendCompleted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
