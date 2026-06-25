import 'package:flutter/material.dart';

import '../../models/resource_article.dart';
import '../../data/resources_en.dart';
import '../../data/resources_pt.dart';

class ResourceService {
  List<ResourceArticle> getResources(Locale? locale) {
    final languageCode = locale?.languageCode ?? 'en';
    switch (languageCode) {
      case 'pt':
        return List.from(resourcesPt);
      default:
        return List.from(resourcesEn);
    }
  }
}
