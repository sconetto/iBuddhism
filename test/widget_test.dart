import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ibuddhism/data/repositories/gongyo_repository.dart';
import 'package:ibuddhism/data/repositories/profile_repository.dart';
import 'package:ibuddhism/data/repositories/resource_repository.dart';
import 'package:ibuddhism/data/services/gongyo_progress_service.dart';
import 'package:ibuddhism/data/services/profile_service.dart';
import 'package:ibuddhism/data/services/resource_service.dart';
import 'package:ibuddhism/ui/app.dart';
import 'package:ibuddhism/ui/features/app/app_view_model.dart';

void main() {
  testWidgets('App renders home navigation', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final profileService = ProfileService(prefs);
    final gongyoService = GongyoProgressService(prefs);
    final resourceService = ResourceService();

    final profileRepository = ProfileRepository(profileService);
    final gongyoRepository = GongyoRepository(gongyoService);
    final resourceRepository = ResourceRepository(resourceService);

    final appViewModel = AppViewModel(profileRepository: profileRepository);

    await tester.pumpWidget(
      MaterialApp(
        home: AppView(
          viewModel: appViewModel,
          profileRepository: profileRepository,
          gongyoRepository: gongyoRepository,
          resourceRepository: resourceRepository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Gongyo'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
  });
}
