import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  static const routeName = '/about';

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  List<InlineSpan> _buildAuthorBodySpans(
    String text,
    TextStyle? baseStyle,
  ) {
    final emojiStyle = baseStyle?.copyWith(
      fontFamilyFallback: const [
        'Apple Color Emoji',
        'Noto Color Emoji',
        'Segoe UI Emoji',
      ],
    );
    final emojiRegex = RegExp(r'(♥️|☕)');
    final spans = <InlineSpan>[];
    var lastIndex = 0;
    for (final match in emojiRegex.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: baseStyle,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: emojiStyle ?? baseStyle,
        ),
      );
      lastIndex = match.end;
    }
    if (lastIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: baseStyle,
        ),
      );
    }
    return spans;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 240),
            children: [
              Text(l10n.aboutHeadline, style: textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(l10n.aboutBody, style: textTheme.bodyLarge),
              const SizedBox(height: 24),
              Text(l10n.homeLocalContentTitle, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.homeLocalContentBody, style: textTheme.bodyMedium),
              const SizedBox(height: 24),
              Text(l10n.aboutAuthorTitle, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: _buildAuthorBodySpans(
                    l10n.aboutAuthorBody,
                    textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
