class ResourceArticle {
  const ResourceArticle({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.paragraphs,
    this.author,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<String> paragraphs;
  final String? author;
}
