import 'package:flutter/material.dart';

import '../../models/resource_article.dart';
import '../services/resource_service.dart';

class ResourceRepository {
  ResourceRepository(this._service);

  final ResourceService _service;

  List<ResourceArticle> getResources(Locale? locale) =>
      _service.getResources(locale);
}
