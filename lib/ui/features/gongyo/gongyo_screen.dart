import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../../core/widgets/glass_nav_bar.dart';
import '../app/app_view_model.dart';
import '../home/home_screen.dart';
import '../resources/resources_list_screen.dart';
import 'gongyo_view_model.dart';
import 'widgets/gongyo_control_bar.dart';
import 'widgets/tempo_pill.dart';

class GongyoScreen extends StatefulWidget {
  const GongyoScreen({
    super.key,
    required this.viewModel,
    required this.appViewModel,
  });

  static const routeName = '/gongyo';

  final GongyoViewModel viewModel;
  final AppViewModel appViewModel;

  @override
  State<GongyoScreen> createState() => _GongyoScreenState();
}

class _GongyoScreenState extends State<GongyoScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _manualExpanded = false;
  double _manualExpandOffset = 0.0;
  bool _didInitFromArgs = false;

  @override
  void initState() {
    super.initState();
    widget.viewModel.init();
    _scrollController.addListener(_handleScroll);
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitFromArgs) return;
    _didInitFromArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      widget.viewModel.handleRouteArgs(args as Map?);
    }
  }

  @override
  void didUpdateWidget(covariant GongyoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_onViewModelChanged);
      widget.viewModel.addListener(_onViewModelChanged);
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
      if (widget.viewModel.currentIndex == 0) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0);
        }
      } else if (widget.viewModel.isPlaying) {
        widget.viewModel.scrollToCurrent();
      }
    }
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
    final vm = widget.viewModel;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(l10n.gongyoTitle),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.gongyoSelectChaptersTitle,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.gongyoSelectChaptersHint,
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  vm.updateChapterSelection(
                                    includeHoben: !vm.includeHoben,
                                  );
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (_scrollController.hasClients) {
                                      _scrollController.jumpTo(0);
                                    }
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: vm.includeHoben
                                      ? colorScheme.primary
                                      : colorScheme.surface,
                                  foregroundColor: vm.includeHoben
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  side: BorderSide(
                                    color: colorScheme.outline
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(l10n.gongyoHoben),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  vm.updateChapterSelection(
                                    includeJuryo: !vm.includeJuryo,
                                  );
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (_scrollController.hasClients) {
                                      _scrollController.jumpTo(0);
                                    }
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: vm.includeJuryo
                                      ? colorScheme.primary
                                      : colorScheme.surface,
                                  foregroundColor: vm.includeJuryo
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  side: BorderSide(
                                    color: colorScheme.outline
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(l10n.gongyoJuryo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.gongyoTempoLabel,
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    tooltip: l10n.gongyoTempoHelp,
                                    iconSize: 18,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          titlePadding:
                                              const EdgeInsets.fromLTRB(
                                                  20, 20, 8, 0),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  l10n.gongyoTempoLabel,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                tooltip:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .closeButtonTooltip,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.close),
                                              ),
                                            ],
                                          ),
                                          content: Text(l10n.gongyoTempoHelp),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '1,0s',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: TempoPill(
                                      value:
                                          '${(vm.intervalMs / 1000).toStringAsFixed(1).replaceAll('.', ',')}s',
                                      color: vm.profile.avatarColorValue != null
                                          ? Color(
                                              vm.profile.avatarColorValue!,
                                            )
                                          : colorScheme.primary,
                                      textStyle: textTheme.bodySmall,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      '2,0s',
                                      style: textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: vm.intervalMs,
                                min: 1000,
                                max: 2000,
                                divisions: 10,
                                onChanged: vm.updateInterval,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Divider(height: 1),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = vm.items[index];
                      if (item.type == GongyoItemType.header) {
                        final sectionTint = item.sectionIndex!.isEven
                            ? colorScheme.primary.withValues(alpha: 0.08)
                            : colorScheme.secondary.withValues(alpha: 0.08);
                        final description =
                            _sectionDescription(l10n, item.sectionId!);
                        return Container(
                          margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: sectionTint,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sectionTitle(l10n, item.sectionId!),
                                style: textTheme.titleMedium,
                              ),
                              if (description != null) ...[
                                const SizedBox(height: 6),
                                Text(description, style: textTheme.bodyMedium),
                              ],
                            ],
                          ),
                        );
                      }

                      final lineIndex = item.lineIndex!;
                      final isActive = lineIndex == vm.currentIndex;
                      final line = item.line!;
                      final sectionTint = item.sectionIndex!.isEven
                          ? colorScheme.primary.withValues(alpha: 0.04)
                          : colorScheme.secondary.withValues(alpha: 0.04);
                      return Container(
                        key: vm.lineKeys[lineIndex],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        color: isActive
                            ? colorScheme.primary.withValues(alpha: 0.12)
                            : sectionTint,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (line.chinese != null) ...[
                              Text(
                                line.chinese!,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontFamily: 'NotoSansSC',
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            Text(
                              line.romanized,
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: isActive
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: vm.items.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: kBottomBarHeight + 24),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: vm.isReciting
                ? GongyoControlBar(
                    isPlaying: vm.isPlaying,
                    isAtStart: vm.currentIndex == 0,
                    onPause: () => vm.pause(),
                    onResume: () => vm.beginRecitation(),
                    onRestart: () => vm.restartRecitation(),
                    onStop: () => vm.stopRecitation(),
                  )
                : GlassNavBar(
                    activeTab: NavTab.gongyo,
                    isCollapsed: _isCollapsed,
                    onExpandRequested: () {
                      setState(() {
                        _isCollapsed = false;
                        _manualExpanded = true;
                        _manualExpandOffset = _scrollController.offset;
                      });
                    },
                    onHomeTap: () {
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName);
                    },
                    onGongyoTap: () {
                      if (_isCollapsed) {
                        setState(() {
                          _isCollapsed = false;
                        });
                        return;
                      }
                      if (!vm.isReciting) {
                        vm.beginRecitation();
                      }
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

  String _sectionTitle(AppLocalizations l10n, String sectionId) {
    switch (sectionId) {
      case 'daimoku_start':
        return l10n.gongyoSectionDaimokuStartTitle;
      case 'hoben':
        return l10n.gongyoSectionHobenTitle;
      case 'juryo':
        return l10n.gongyoSectionJuryoTitle;
      case 'daimoku_end':
        return l10n.gongyoSectionDaimokuEndTitle;
    }
    return sectionId;
  }

  String? _sectionDescription(AppLocalizations l10n, String sectionId) {
    switch (sectionId) {
      case 'daimoku_start':
        return l10n.gongyoSectionDaimokuStartDescription;
      case 'hoben':
        return l10n.gongyoSectionHobenDescription;
      case 'juryo':
        return l10n.gongyoSectionJuryoDescription;
      case 'daimoku_end':
        return l10n.gongyoSectionDaimokuEndDescription;
    }
    return null;
  }
}
