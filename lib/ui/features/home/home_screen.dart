import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../../core/widgets/glass_nav_bar.dart';
import '../app/app_view_model.dart';
import '../about/about_screen.dart';
import '../gongyo/gongyo_screen.dart';
import '../resources/resources_list_screen.dart';
import '../settings/settings_screen.dart';
import 'home_view_model.dart';
import 'widgets/calendar_card.dart';
import 'widgets/home_profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
    required this.appViewModel,
  });

  static const routeName = '/';

  final HomeViewModel viewModel;
  final AppViewModel appViewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _manualExpanded = false;
  double _manualExpandOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_onViewModelChanged);
      widget.viewModel.addListener(_onViewModelChanged);
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final profile = widget.appViewModel.profile;
    final avatarBaseColor = profile.avatarColorValue != null
        ? Color(profile.avatarColorValue!)
        : colorScheme.primary;
    final timeOfDay = _timeGreeting(l10n);
    final timeGreeting = timeOfDay.isEmpty
        ? ''
        : '${timeOfDay[0].toUpperCase()}${timeOfDay.substring(1)}!';
    final rawName = (profile.name ?? '').trim();
    final name = rawName.isEmpty ? '' : rawName.split(RegExp(r'\s+')).first;
    final vm = widget.viewModel;
    final displayMonthKey = vm.monthKey(vm.displayMonth);
    final monthlyWeeklyGoal =
        vm.monthlyGoals[displayMonthKey] ?? profile.gongyoWeeklyGoal;

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
              child: HomeProfileAvatar(profile: profile),
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
              final themeMode = widget.appViewModel.themeMode;
              if (themeMode == ThemeMode.dark) {
                return Icons.dark_mode_outlined;
              }
              if (themeMode == ThemeMode.light) {
                return Icons.light_mode_outlined;
              }
              final brightness = Theme.of(context).brightness;
              return brightness == Brightness.dark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined;
            }()),
            onSelected: widget.appViewModel.updateThemeMode,
            itemBuilder: (context) => [
              _themeMenuItem(
                l10n.themeAuto,
                ThemeMode.system,
                widget.appViewModel.themeMode,
                textTheme,
              ),
              _themeMenuItem(
                l10n.themeLight,
                ThemeMode.light,
                widget.appViewModel.themeMode,
                textTheme,
              ),
              _themeMenuItem(
                l10n.themeDark,
                ThemeMode.dark,
                widget.appViewModel.themeMode,
                textTheme,
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
                  CalendarCard(
                    locale: widget.appViewModel.locale,
                    progress: vm.progress,
                    month: vm.displayMonth,
                    weeklyGoal: monthlyWeeklyGoal,
                    baseColor: avatarBaseColor,
                    onPreviousMonth: () => vm.changeMonth(-1),
                    onToday: () => vm.goToToday(),
                    onNextMonth: () => vm.changeMonth(1),
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
                  GongyoScreen.routeName,
                  arguments: const {'showControls': true},
                );
              },
              onLibraryTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  ResourcesListScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<ThemeMode> _themeMenuItem(
    String label,
    ThemeMode value,
    ThemeMode current,
    TextTheme textTheme,
  ) {
    return PopupMenuItem(
      value: value,
      child: Text(
        label,
        style: value == current
            ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)
            : textTheme.bodyMedium,
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
