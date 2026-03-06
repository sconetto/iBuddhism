class ResourceArticle {
  const ResourceArticle({
    required this.id,
    required this.sequence,
    required this.title,
    required this.subtitle,
    required this.content,
    this.author,
  });

  final String id;
  final int sequence;
  final String title;
  final String subtitle;
  final String content;
  final String? author;
}
