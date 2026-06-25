import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../data/repositories/gongyo_repository.dart';
import '../data/repositories/resource_repository.dart';
import 'core/theme/app_materials.dart';
import 'features/about/about_screen.dart';
import 'features/app/app_view_model.dart';
import 'features/gongyo/gongyo_screen.dart';
import 'features/gongyo/gongyo_view_model.dart';
import 'features/home/home_screen.dart';
import 'features/home/home_view_model.dart';
import 'features/resources/resources_list_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/settings/settings_view_model.dart';
import '../../data/repositories/profile_repository.dart';

class AppView extends StatelessWidget {
  const AppView({
    super.key,
    required this.viewModel,
    required this.profileRepository,
    required this.gongyoRepository,
    required this.resourceRepository,
  });

  final AppViewModel viewModel;
  final ProfileRepository profileRepository;
  final GongyoRepository gongyoRepository;
  final ResourceRepository resourceRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) => _AppBody(
        viewModel: viewModel,
        profileRepository: profileRepository,
        gongyoRepository: gongyoRepository,
        resourceRepository: resourceRepository,
      ),
    );
  }
}

class _AppBody extends StatelessWidget {
  const _AppBody({
    required this.viewModel,
    required this.profileRepository,
    required this.gongyoRepository,
    required this.resourceRepository,
  });

  final AppViewModel viewModel;
  final ProfileRepository profileRepository;
  final GongyoRepository gongyoRepository;
  final ResourceRepository resourceRepository;

  @override
  Widget build(BuildContext context) {
    const lightScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0F1A18),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFFDED9E2),
      onSecondary: Color(0xFF0F1A18),
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFCF4EE),
      onSurface: Color(0xFF0F1A18),
    );

    const darkScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFCF4EE),
      onPrimary: Color(0xFF0F1A18),
      secondary: Color(0xFFDED9E2),
      onSecondary: Color(0xFF0F1A18),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: Color(0xFF0F1A18),
      onSurface: Color(0xFFFCF4EE),
    );

    const baseTextTheme = TextTheme(
      headlineSmall: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.6,
      ),
    );

    final theme = ThemeData(
      colorScheme: lightScheme,
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      useMaterial3: true,
      textTheme: baseTextTheme.apply(
        bodyColor: lightScheme.onSurface,
        displayColor: lightScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF0F1A18),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      extensions: const [
        defaultGlassMaterial,
      ],
    );

    final darkTheme = ThemeData(
      colorScheme: darkScheme,
      scaffoldBackgroundColor: const Color(0xFF0F1A18),
      useMaterial3: true,
      textTheme: baseTextTheme.apply(
        bodyColor: darkScheme.onSurface,
        displayColor: darkScheme.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: Color(0xFF0F1A18),
        foregroundColor: Color(0xFFFCF4EE),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      extensions: const [
        defaultGlassMaterial,
      ],
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: viewModel.themeMode,
      locale: viewModel.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) => _onGenerateRoute(
        settings,
        viewModel,
        profileRepository,
        gongyoRepository,
        resourceRepository,
      ),
    );
  }
}

Route<dynamic> _onGenerateRoute(
  RouteSettings settings,
  AppViewModel appViewModel,
  ProfileRepository profileRepository,
  GongyoRepository gongyoRepository,
  ResourceRepository resourceRepository,
) {
  final name = settings.name ?? HomeScreen.routeName;

  if (name == SettingsScreen.routeName || name == AboutScreen.routeName) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => _buildPage(
        name,
        appViewModel,
        profileRepository,
        gongyoRepository,
        resourceRepository,
      ),
    );
  }

  final fromIndex = _tabIndex(appViewModel.currentRouteName);
  final toIndex = _tabIndex(name);
  appViewModel.currentRouteName = name;

  final isForward = toIndex >= fromIndex;
  final beginOffset = toIndex == fromIndex
      ? const Offset(0, 0)
      : (isForward ? const Offset(-0.12, 0) : const Offset(0.12, 0));

  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (_, __, ___) => _buildPage(
      name,
      appViewModel,
      profileRepository,
      gongyoRepository,
      resourceRepository,
    ),
    transitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      final slide = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(curved);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

int _tabIndex(String? routeName) {
  switch (routeName) {
    case '/':
      return 0;
    case '/gongyo':
      return 1;
    case '/resources':
      return 2;
  }
  return 0;
}

Widget _buildPage(
  String routeName,
  AppViewModel appViewModel,
  ProfileRepository profileRepository,
  GongyoRepository gongyoRepository,
  ResourceRepository resourceRepository,
) {
  switch (routeName) {
    case '/':
      final viewModel = HomeViewModel(
        gongyoRepository: gongyoRepository,
        appViewModel: appViewModel,
      );
      return HomeScreen(viewModel: viewModel, appViewModel: appViewModel);
    case '/gongyo':
      final viewModel = GongyoViewModel(
        gongyoRepository: gongyoRepository,
        appViewModel: appViewModel,
      );
      return GongyoScreen(viewModel: viewModel, appViewModel: appViewModel);
    case '/resources':
      return ResourcesListScreen(
        resourceRepository: resourceRepository,
        appViewModel: appViewModel,
      );
    case '/about':
      return const AboutScreen();
    case '/settings':
      final viewModel = SettingsViewModel(
        appViewModel: appViewModel,
      );
      return SettingsScreen(
        viewModel: viewModel,
        appViewModel: appViewModel,
      );
  }
  return HomeScreen(
    viewModel: HomeViewModel(
      gongyoRepository: gongyoRepository,
      appViewModel: appViewModel,
    ),
    appViewModel: appViewModel,
  );
}
