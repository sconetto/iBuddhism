import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import 'about_screen.dart';
import 'gongyo_rhythmic_screen.dart';
import 'resources_list_screen.dart';
import 'settings_screen.dart';
import '../widgets/glass_nav_bar.dart';
import '../models/profile.dart';
import '../models/gongyo_progress.dart';
import '../services/gongyo_progress_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.locale,
    required this.onLocaleChanged,
    required this.profile,
  });

  static const routeName = '/';

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;
  final UserProfile profile;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _manualExpanded = false;
  double _manualExpandOffset = 0.0;
  Map<String, GongyoProgressStatus> _progress = {};
  Map<String, int> _monthlyGoals = {};
  DateTime _displayMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _loadProgress();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.gongyoWeeklyGoal != widget.profile.gongyoWeeklyGoal) {
      _ensureMonthlyGoal(_displayMonth);
      _updateCurrentMonthGoal();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (_manualExpanded) {
      if ((_scrollController.offset - _manualExpandOffset).abs() < 0.5) {
        return;
      }
      _manualExpanded = false;
    }
    final shouldCollapse = _scrollController.offset > 32;
    if (shouldCollapse != _isCollapsed) {
      setState(() {
        _isCollapsed = shouldCollapse;
      });
    }
  }

  Future<void> _loadProgress() async {
    final store = await GongyoProgressStore.load();
    if (!mounted) {
      return;
    }
    final progress = store.getAll();
    final monthlyGoals = store.getMonthlyGoals();
    if (kDebugMode) {
      _applyDebugMocks(progress, monthlyGoals);
    }
    setState(() {
      _progress = progress;
      _monthlyGoals = monthlyGoals;
    });
    _ensureMonthlyGoal(_displayMonth);
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
    });
    _ensureMonthlyGoal(_displayMonth);
  }

  String _monthKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}';
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  void _applyDebugMocks(
    Map<String, GongyoProgressStatus> progress,
    Map<String, int> monthlyGoals,
  ) {
    final now = DateTime.now();
    for (final delta in [1, 2]) {
      final target = DateTime(now.year, now.month - delta);
      final key = _monthKey(target);
      if (!monthlyGoals.containsKey(key)) {
        monthlyGoals[key] = widget.profile.gongyoWeeklyGoal;
      }
      final daysInMonth = DateTime(target.year, target.month + 1, 0).day;
      if (delta == 1) {
        final noneDays = {4, 12};
        final startedDays = {8, 19};
        for (var day = 1; day <= daysInMonth; day++) {
          if (noneDays.contains(day)) {
            continue;
          }
          final date = DateTime(target.year, target.month, day);
          final status = startedDays.contains(day)
              ? GongyoProgressStatus.started
              : GongyoProgressStatus.completed;
          progress.putIfAbsent(_dateKey(date), () => status);
        }
      } else {
        final sampleDays = [2, 5, 9, 13, 17, 21, 25]
            .where((day) => day <= daysInMonth)
            .toList();
        for (var i = 0; i < sampleDays.length; i++) {
          final date = DateTime(target.year, target.month, sampleDays[i]);
          final status = i.isEven
              ? GongyoProgressStatus.completed
              : GongyoProgressStatus.started;
          progress.putIfAbsent(_dateKey(date), () => status);
        }
      }
    }
  }

  Future<void> _ensureMonthlyGoal(DateTime date) async {
    final key = _monthKey(date);
    if (_monthlyGoals.containsKey(key)) {
      return;
    }
    final store = await GongyoProgressStore.load();
    await store.setMonthlyGoal(key, widget.profile.gongyoWeeklyGoal);
    if (!mounted) {
      return;
    }
    setState(() {
      _monthlyGoals = {
        ..._monthlyGoals,
        key: widget.profile.gongyoWeeklyGoal,
      };
    });
  }

  Future<void> _updateCurrentMonthGoal() async {
    final nowKey = _monthKey(DateTime.now());
    final currentValue = _monthlyGoals[nowKey];
    if (currentValue == widget.profile.gongyoWeeklyGoal) {
      return;
    }
    final store = await GongyoProgressStore.load();
    await store.setMonthlyGoal(nowKey, widget.profile.gongyoWeeklyGoal);
    if (!mounted) {
      return;
    }
    setState(() {
      _monthlyGoals = {
        ..._monthlyGoals,
        nowKey: widget.profile.gongyoWeeklyGoal,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final avatarBaseColor = widget.profile.avatarColorValue != null
        ? Color(widget.profile.avatarColorValue!)
        : Theme.of(context).colorScheme.primary;
    final timeOfDay = _timeGreeting(l10n);
    final timeGreeting = timeOfDay.isEmpty
        ? ''
        : '${timeOfDay[0].toUpperCase()}${timeOfDay.substring(1)}!';
    final rawName = (widget.profile.name ?? '').trim();
    final name = rawName.isEmpty ? '' : rawName.split(RegExp(r'\s+')).first;
    final displayMonthKey = _monthKey(_displayMonth);
    final monthlyWeeklyGoal =
        _monthlyGoals[displayMonthKey] ?? widget.profile.gongyoWeeklyGoal;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
              child: _HomeProfileAvatar(profile: widget.profile),
            ),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 22,
              color: colorScheme.outline.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/lotus-flower.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Text(l10n.appTitle),
          ],
        ),
        actions: [
          PopupMenuButton<ThemeMode>(
            icon: Icon(() {
              if (widget.themeMode == ThemeMode.dark) {
                return Icons.dark_mode_outlined;
              }
              if (widget.themeMode == ThemeMode.light) {
                return Icons.light_mode_outlined;
              }
              final brightness = Theme.of(context).brightness;
              return brightness == Brightness.dark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined;
            }()),
            onSelected: widget.onThemeModeChanged,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.system,
                child: Text(
                  l10n.themeAuto,
                  style: widget.themeMode == ThemeMode.system
                      ? textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : textTheme.bodyMedium,
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.light,
                child: Text(
                  l10n.themeLight,
                  style: widget.themeMode == ThemeMode.light
                      ? textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : textTheme.bodyMedium,
                ),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Text(
                  l10n.themeDark,
                  style: widget.themeMode == ThemeMode.dark
                      ? textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: l10n.navAbout,
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, AboutScreen.routeName);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, kBottomBarHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty
                        ? l10n.homeGreetingLineOneNoName
                        : l10n.homeGreetingLineOneWithName(name),
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeGreeting,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.homeSubhead,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  _GongyoCalendarCard(
                    locale: widget.locale,
                    progress: _progress,
                    month: _displayMonth,
                    weeklyGoal: monthlyWeeklyGoal,
                    baseColor: avatarBaseColor,
                    onPreviousMonth: () => _changeMonth(-1),
                    onToday: () {
                      setState(() {
                        _displayMonth = DateTime.now();
                      });
                      _ensureMonthlyGoal(DateTime.now());
                    },
                    onNextMonth: () => _changeMonth(1),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassNavBar(
              activeTab: NavTab.home,
              isCollapsed: _isCollapsed,
              onExpandRequested: () {
                setState(() {
                  _isCollapsed = false;
                  _manualExpanded = true;
                  _manualExpandOffset = _scrollController.offset;
                });
              },
              onHomeTap: () {},
              onGongyoTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  GongyoRhythmicScreen.routeName,
                  arguments: const {'showControls': true},
                );
              },
              onLibraryTap: () {
                Navigator.pushReplacementNamed(
                    context, ResourcesListScreen.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }

  String _timeGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour >= 19 || hour < 5) {
      return l10n.homeTimeNight;
    }
    if (hour >= 5 && hour < 13) {
      return l10n.homeTimeDay;
    }
    return l10n.homeTimeAfternoon;
  }
}

class _GongyoCalendarCard extends StatelessWidget {
  const _GongyoCalendarCard({
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
    final startOffset = monthStart.weekday % 7; // Sunday = 0
    final totalCells = ((startOffset + daysInMonth + 6) / 7).floor() * 7;
    final weeksInMonth = (daysInMonth / 7).ceil();
    final goalDays = weeklyGoal * weeksInMonth;

    Color statusColor(GongyoProgressStatus status) {
      if (!isDark) {
        switch (status) {
          case GongyoProgressStatus.completed:
            return _tintColor(baseColor, 0.4);
          case GongyoProgressStatus.started:
            return _tintColor(baseColor, 0.6);
          case GongyoProgressStatus.none:
            return _tintColor(baseColor, 0.85);
        }
      }
      switch (status) {
        case GongyoProgressStatus.completed:
          return _shadeColor(baseColor, 0.9);
        case GongyoProgressStatus.started:
          return _shadeColor(baseColor, 0.5);
        case GongyoProgressStatus.none:
          return _shadeColor(baseColor, 0.1);
      }
    }

    String dateKey(DateTime date) {
      return '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')}';
    }

    List<String> weekdayLabels() {
      final base = DateTime(2023, 1, 1); // Sunday
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
          _CalendarLegend(
            baseColor: baseColor,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _CalendarProgressSection(
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

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({
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

class _CalendarProgressSection extends StatelessWidget {
  const _CalendarProgressSection({
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

class _HomeProfileAvatar extends StatelessWidget {
  const _HomeProfileAvatar({required this.profile});

  final UserProfile profile;

  String _initials(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) {
      return '?';
    }
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts.first.characters.take(1).toString() +
            parts.last.characters.take(1).toString())
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final fallbackColor = Theme.of(context).colorScheme.primary;
    final color = profile.avatarColorValue != null
        ? Color(profile.avatarColorValue!)
        : fallbackColor;
    final imagePath = profile.avatarPath;
    final file = imagePath != null ? File(imagePath) : null;
    final hasImage = file != null && file.existsSync();
    final textColor =
        color.computeLuminance() > 0.7 ? Colors.black : Colors.white;

    return CircleAvatar(
      radius: 16,
      backgroundColor: color.withValues(alpha: 0.15),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: color,
        backgroundImage: hasImage ? FileImage(file) : null,
        child: hasImage
            ? null
            : Text(
                _initials(profile.name),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
      ),
    );
  }
}
