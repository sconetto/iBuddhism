import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/gongyo_rhythmic.dart';
import '../../../data/repositories/gongyo_repository.dart';
import '../../../models/gongyo_progress.dart';
import '../../../models/profile.dart';
import '../app/app_view_model.dart';

enum GongyoItemType { header, line }

class GongyoItem {
  const GongyoItem.header({
    required this.sectionId,
    required this.sectionIndex,
  })  : type = GongyoItemType.header,
        line = null,
        lineIndex = null;

  const GongyoItem.line({
    required this.line,
    required this.lineIndex,
    required this.sectionIndex,
  })  : type = GongyoItemType.line,
        sectionId = null;

  final GongyoItemType type;
  final String? sectionId;
  final GongyoLine? line;
  final int? lineIndex;
  final int? sectionIndex;
}

List<GongyoItem> buildGongyoItems({
  required bool includeHoben,
  required bool includeJuryo,
}) {
  final items = <GongyoItem>[];
  var lineIndex = 0;
  var sectionIndex = 0;
  for (final section in gongyoSections) {
    if (section.id == 'hoben' && !includeHoben) continue;
    if (section.id == 'juryo' && !includeJuryo) continue;
    items.add(GongyoItem.header(
      sectionId: section.id,
      sectionIndex: sectionIndex,
    ));
    for (final line in section.lines) {
      items.add(GongyoItem.line(
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

class _SectionLoop {
  final int startLineIndex;
  final int endLineIndex;
  final int totalLoops;
  int completedLoops = 1;

  _SectionLoop({
    required this.startLineIndex,
    required this.endLineIndex,
    required this.totalLoops,
  });

  bool get isExhausted => completedLoops >= totalLoops;
}

class GongyoViewModel extends ChangeNotifier {
  GongyoViewModel({
    required GongyoRepository gongyoRepository,
    required AppViewModel appViewModel,
  })  : _gongyoRepository = gongyoRepository,
        _appViewModel = appViewModel;

  final GongyoRepository _gongyoRepository;
  final AppViewModel _appViewModel;

  List<GongyoItem> _items = [];
  late List<GlobalKey> _lineKeys;
  List<_SectionLoop> _sectionLoops = [];
  Timer? _timer;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isReciting = false;
  double _intervalMs = gongyoDefaultIntervalMs.toDouble();
  bool _includeHoben = true;
  bool _includeJuryo = true;

  List<GongyoItem> get items => _items;
  List<GlobalKey> get lineKeys => _lineKeys;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isReciting => _isReciting;
  double get intervalMs => _intervalMs;
  bool get includeHoben => _includeHoben;
  bool get includeJuryo => _includeJuryo;
  UserProfile get profile => _appViewModel.profile;

  void init() {
    _rebuildItems();
  }

  void handleRouteArgs(Map? args) {
    if (args != null && args['showControls'] == true && !_isReciting) {
      _isReciting = true;
      _isPlaying = false;
      notifyListeners();
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _markStarted() async {
    await _gongyoRepository.setStatus(
        _todayKey(), GongyoProgressStatus.started);
  }

  Future<void> _markCompleted() async {
    await _gongyoRepository.setStatus(
        _todayKey(), GongyoProgressStatus.completed);
  }

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(milliseconds: _intervalMs.round()),
      (_) => _advance(),
    );
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _timer?.cancel();
    _isPlaying = false;
    notifyListeners();
  }

  void beginRecitation() {
    if (!_isReciting) {
      _isReciting = true;
      notifyListeners();
    }
    _markStarted();
    start();
  }

  void restartRecitation() {
    _timer?.cancel();
    _resetLoops();
    _currentIndex = 0;
    _isReciting = true;
    _isPlaying = true;
    notifyListeners();
    _markStarted();
    start();
  }

  void stopRecitation() {
    pause();
    _resetLoops();
    _currentIndex = 0;
    _isReciting = false;
    notifyListeners();
  }

  void _resetLoops() {
    for (final loop in _sectionLoops) {
      loop.completedLoops = 1;
    }
  }

  void _rebuildItems() {
    _items = buildGongyoItems(
      includeHoben: _includeHoben,
      includeJuryo: _includeJuryo,
    );
    _lineKeys = List.generate(
      _items.where((item) => item.type == GongyoItemType.line).length,
      (_) => GlobalKey(),
    );
    _sectionLoops = [];
    var lineIdx = 0;
    for (final section in gongyoSections) {
      if (section.id == 'hoben' && !_includeHoben) continue;
      if (section.id == 'juryo' && !_includeJuryo) continue;
      if (section.lines.isNotEmpty && section.loop > 1) {
        _sectionLoops.add(_SectionLoop(
          startLineIndex: lineIdx,
          endLineIndex: lineIdx + section.lines.length - 1,
          totalLoops: section.loop,
        ));
      }
      lineIdx += section.lines.length;
    }
  }

  void updateChapterSelection({bool? includeHoben, bool? includeJuryo}) {
    final nextIncludeHoben = includeHoben ?? _includeHoben;
    final nextIncludeJuryo = includeJuryo ?? _includeJuryo;
    if (!nextIncludeHoben && !nextIncludeJuryo) return;

    _includeHoben = nextIncludeHoben;
    _includeJuryo = nextIncludeJuryo;
    _currentIndex = 0;
    _rebuildItems();
    notifyListeners();
  }

  void _advance() {
    if (_currentIndex >= _lineKeys.length - 1) {
      _markCompleted();
      pause();
      return;
    }

    final nextIndex = _currentIndex + 1;
    bool wrapped = false;
    for (final loop in _sectionLoops) {
      if (nextIndex > loop.endLineIndex && !loop.isExhausted) {
        loop.completedLoops += 1;
        _currentIndex = loop.startLineIndex;
        wrapped = true;
        break;
      }
    }

    if (!wrapped) {
      _currentIndex = nextIndex;
    }

    notifyListeners();
  }

  void updateInterval(double value) {
    _intervalMs = value;
    notifyListeners();
    if (_isPlaying) {
      _timer?.cancel();
      start();
    } else {
      _timer?.cancel();
    }
  }

  void scrollToCurrent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _lineKeys[_currentIndex];
      final context = key.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0.3,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
