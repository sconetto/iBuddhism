import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../data/resources_pt.dart';
import '../models/resource_article.dart';
import 'resource_detail_screen.dart';
import '../screens/gongyo_rhythmic_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/glass_nav_bar.dart';

class ResourcesListScreen extends StatefulWidget {
  const ResourcesListScreen({super.key});

  static const routeName = '/resources';

  @override
  State<ResourcesListScreen> createState() => _ResourcesListScreenState();
}

class _ResourcesListScreenState extends State<ResourcesListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;
  bool _manualExpanded = false;
  double _manualExpandOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(l10n.libraryTitle),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: resourcesPt.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = resourcesPt[index];
              return _ResourceListTile(article: article);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassNavBar(
              activeTab: NavTab.library,
              isCollapsed: _isCollapsed,
              onExpandRequested: () {
                setState(() {
                  _isCollapsed = false;
                  _manualExpanded = true;
                  _manualExpandOffset = _scrollController.offset;
                });
              },
              onHomeTap: () {
                Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              },
              onGongyoTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  GongyoRhythmicScreen.routeName,
                  arguments: const {'showControls': true},
                );
              },
              onLibraryTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceListTile extends StatelessWidget {
  const _ResourceListTile({required this.article});

  final ResourceArticle article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(article.title),
      subtitle: Text(article.subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResourceDetailScreen(article: article),
          ),
        );
      },
    );
  }
}
