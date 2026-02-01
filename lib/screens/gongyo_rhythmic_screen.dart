import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../data/gongyo_rhythmic.dart';
import '../models/gongyo_progress.dart';
import '../models/profile.dart';
import '../services/gongyo_progress_store.dart';
import '../screens/home_screen.dart';
import '../screens/resources_list_screen.dart';
import '../widgets/glass_nav_bar.dart';
import '../theme/app_materials.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GongyoRhythmicScreen extends StatefulWidget {
  const GongyoRhythmicScreen({
    super.key,
    required this.profile,
  });

  static const routeName = '/gongyo';

  final UserProfile profile;

  @override
  State<GongyoRhythmicScreen> createState() => _GongyoRhythmicScreenState();
}

class _GongyoRhythmicScreenState extends State<GongyoRhythmicScreen> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _lineKeys;
  late List<_GongyoItem> _items;
  Timer? _timer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isReciting = false;
  double _intervalMs = gongyoDefaultIntervalMs.toDouble();
  bool _includeHoben = true;
  bool _includeJuryo = true;
  bool _isCollapsed = false;
  bool _didInitFromArgs = false;
  bool _manualExpanded = false;
  double _manualExpandOffset = 0.0;

  Future<void> _markStarted() async {
    final store = await GongyoProgressStore.load();
    await store.setStatus(_todayKey(), GongyoProgressStatus.started);
  }

  Future<void> _markCompleted() async {
    final store = await GongyoProgressStore.load();
    await store.setStatus(_todayKey(), GongyoProgressStatus.completed);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _rebuildItems();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitFromArgs) {
      return;
    }
    _didInitFromArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['showControls'] == true && !_isReciting) {
      setState(() {
        _isReciting = true;
        _isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
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

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: _intervalMs.round()),
      (_) => _advance(),
    );
    setState(() {
      _isPlaying = true;
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
    });
  }

  void _beginRecitation() {
    if (!_isReciting) {
      setState(() {
        _isReciting = true;
      });
    }
    _markStarted();
    _start();
  }

  void _restartRecitation() {
    _timer?.cancel();
    setState(() {
      _currentIndex = 0;
      _isReciting = true;
      _isPlaying = true;
    });
    _markStarted();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      _start();
    });
  }

  void _stopRecitation() {
    _pause();
    setState(() {
      _isReciting = false;
    });
  }

  void _rebuildItems() {
    _items = _buildItems(
      includeHoben: _includeHoben,
      includeJuryo: _includeJuryo,
    );
    _lineKeys = List.generate(
      _items.where((item) => item.type == _GongyoItemType.line).length,
      (_) => GlobalKey(),
    );
  }

  void _updateChapterSelection({bool? includeHoben, bool? includeJuryo}) {
    final nextIncludeHoben = includeHoben ?? _includeHoben;
    final nextIncludeJuryo = includeJuryo ?? _includeJuryo;

    if (!nextIncludeHoben && !nextIncludeJuryo) {
      return;
    }

    setState(() {
      _includeHoben = nextIncludeHoben;
      _includeJuryo = nextIncludeJuryo;
      _currentIndex = 0;
      _rebuildItems();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  void _advance() {
    if (_currentIndex >= _lineKeys.length - 1) {
      _markCompleted();
      _pause();
      return;
    }
    setState(() {
      _currentIndex += 1;
    });
    _scrollToCurrent();
  }

  void _scrollToCurrent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _lineKeys[_currentIndex];
      final context = key.currentContext;
      if (context == null) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.3,
      );
    });
  }

  void _updateInterval(double value) {
    setState(() {
      _intervalMs = value;
    });
    if (_isPlaying) {
      _start();
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
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
                                  _updateChapterSelection(
                                    includeHoben: !_includeHoben,
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: _includeHoben
                                      ? colorScheme.primary
                                      : colorScheme.surface,
                                  foregroundColor: _includeHoben
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
                                  _updateChapterSelection(
                                    includeJuryo: !_includeJuryo,
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: _includeJuryo
                                      ? colorScheme.primary
                                      : colorScheme.surface,
                                  foregroundColor: _includeJuryo
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
                                    child: _TempoValuePill(
                                      value:
                                          '${(_intervalMs / 1000).toStringAsFixed(1).replaceAll('.', ',')}s',
                                      color: widget.profile.avatarColorValue !=
                                              null
                                          ? Color(
                                              widget.profile.avatarColorValue!,
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
                                value: _intervalMs,
                                min: 1000,
                                max: 2000,
                                divisions: 10,
                                onChanged: _updateInterval,
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
                      final item = _items[index];
                      if (item.type == _GongyoItemType.header) {
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
                      final isActive = lineIndex == _currentIndex;
                      final line = item.line!;
                      final sectionTint = item.sectionIndex!.isEven
                          ? colorScheme.primary.withValues(alpha: 0.04)
                          : colorScheme.secondary.withValues(alpha: 0.04);
                      return Container(
                        key: _lineKeys[lineIndex],
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
                    childCount: _items.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _isReciting
                ? _GongyoControlBar(
                    isPlaying: _isPlaying,
                    isAtStart: _currentIndex == 0,
                    onPause: _pause,
                    onResume: _beginRecitation,
                    onRestart: _restartRecitation,
                    onStop: _stopRecitation,
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
                      if (!_isReciting) {
                        setState(() {
                          _isReciting = true;
                          _isPlaying = false;
                        });
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
}

class _TempoValuePill extends StatelessWidget {
  const _TempoValuePill({
    required this.value,
    required this.color,
    this.textStyle,
  });

  final String value;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textColor =
        color.computeLuminance() > 0.6 ? Colors.black : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: textStyle?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GongyoControlBar extends StatelessWidget {
  const _GongyoControlBar({
    required this.isPlaying,
    required this.isAtStart,
    required this.onPause,
    required this.onResume,
    required this.onRestart,
    required this.onStop,
  });

  final bool isPlaying;
  final bool isAtStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final glass =
        Theme.of(context).extension<GlassMaterial>() ?? defaultGlassMaterial;
    final stopLabel =
        (isAtStart && !isPlaying) ? l10n.gongyoExit : l10n.gongyoStop;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: kBottomBarHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: LiquidGlassLayer(
            fake: false,
            settings: LiquidGlassSettings(
              thickness: 10,
              blur: glass.blurSigma,
              glassColor: colorScheme.surface.withValues(alpha: 0.10),
              lightIntensity: 1.5,
              saturation: 1.2,
            ),
            child: LiquidGlassBlendGroup(
              blend: 18,
              child: LiquidGlass.grouped(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: glass.cornerRadius,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(glass.cornerRadius),
                    border: Border.all(
                      color: colorScheme.outline
                          .withValues(alpha: glass.borderAlpha),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow
                            .withValues(alpha: glass.shadowAlpha),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ControlGlassButton(
                          label: isPlaying
                              ? l10n.gongyoPause
                              : (isAtStart
                                  ? l10n.gongyoStart
                                  : l10n.gongyoResume),
                          icon: isPlaying ? Icons.pause : Icons.play_arrow,
                          onTap: isPlaying ? onPause : onResume,
                          isActive: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ControlGlassButton(
                          label: l10n.gongyoRestart,
                          icon: Icons.refresh,
                          onTap: onRestart,
                          isActive: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ControlGlassButton(
                          label: stopLabel,
                          icon: Icons.stop_circle_outlined,
                          onTap: onStop,
                          isActive: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlGlassButton extends StatelessWidget {
  const _ControlGlassButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurface),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

enum _GongyoItemType { header, line }

class _GongyoItem {
  const _GongyoItem.header({
    required this.sectionId,
    required this.sectionIndex,
  })  : type = _GongyoItemType.header,
        line = null,
        lineIndex = null;

  const _GongyoItem.line({
    required this.line,
    required this.lineIndex,
    required this.sectionIndex,
  })  : type = _GongyoItemType.line,
        sectionId = null;

  final _GongyoItemType type;
  final String? sectionId;
  final GongyoLine? line;
  final int? lineIndex;
  final int? sectionIndex;
}

List<_GongyoItem> _buildItems({
  required bool includeHoben,
  required bool includeJuryo,
}) {
  final items = <_GongyoItem>[];
  var lineIndex = 0;
  var sectionIndex = 0;
  for (final section in gongyoSections) {
    if (section.id == 'hoben' && !includeHoben) {
      continue;
    }
    if (section.id == 'juryo' && !includeJuryo) {
      continue;
    }
    items.add(_GongyoItem.header(
      sectionId: section.id,
      sectionIndex: sectionIndex,
    ));
    for (final line in section.lines) {
      items.add(_GongyoItem.line(
        line: line,
        lineIndex: lineIndex,
        sectionIndex: sectionIndex,
      ));
      lineIndex += 1;
    }
    sectionIndex += 1;
  }
  return items;
}
