import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../models/resource_article.dart';

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key, required this.article});

  final ResourceArticle article;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
          // Leaving the app bar empty to keep the back button
          ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              Text(article.subtitle,
                  style: textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 16),
              MarkdownBody(
                data: article.content,
                styleSheet:
                    MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: textTheme.bodyLarge,
                  textAlign: WrapAlignment.spaceBetween,
                  pPadding: const EdgeInsets.only(bottom: 16),
                ),
              ),
              if (article.author != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.resourceSource(article.author!),
                  style: textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
