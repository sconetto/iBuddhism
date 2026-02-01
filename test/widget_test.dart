// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ibuddhism/main.dart';
import 'package:ibuddhism/models/profile.dart';

void main() {
  testWidgets('App renders home navigation', (WidgetTester tester) async {
    await tester.pumpWidget(
      IBuddhismApp(
        initialThemeMode: ThemeMode.system,
        initialLocale: const Locale('en'),
        initialProfile: const UserProfile(
          name: null,
          bio: null,
          avatarColorValue: null,
          avatarPath: null,
          dateOfBirth: null,
          gongyoWeeklyGoal: 5,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Gongyo'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
  });
}
