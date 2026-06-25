import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/repositories/gongyo_repository.dart';
import 'data/repositories/profile_repository.dart';
import 'data/repositories/resource_repository.dart';
import 'data/services/gongyo_progress_service.dart';
import 'data/services/profile_service.dart';
import 'data/services/resource_service.dart';
import 'ui/app.dart';
import 'ui/features/app/app_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  final prefs = await SharedPreferences.getInstance();

  final profileService = ProfileService(prefs);
  final gongyoService = GongyoProgressService(prefs);
  final resourceService = ResourceService();

  final profileRepository = ProfileRepository(profileService);
  final gongyoRepository = GongyoRepository(gongyoService);
  final resourceRepository = ResourceRepository(resourceService);

  final appViewModel = AppViewModel(profileRepository: profileRepository);

  runApp(LiquidGlassWidgets.wrap(
    child: AppView(
      viewModel: appViewModel,
      profileRepository: profileRepository,
      gongyoRepository: gongyoRepository,
      resourceRepository: resourceRepository,
    ),
  ));
}
