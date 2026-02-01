import 'package:flutter/material.dart';
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
        title: Text(article.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.subtitle, style: textTheme.titleMedium),
              const SizedBox(height: 16),
              for (final paragraph in article.paragraphs) ...[
                Text(paragraph, style: textTheme.bodyLarge),
                const SizedBox(height: 16),
              ],
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
