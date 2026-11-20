import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_view.dart';

void main() {
  group('SettingsView Widget Tests', () {
    testWidgets('defaults to dark mode switch enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SettingsView()),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark mode'), findsOneWidget);

      final SwitchListTile toggle =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(toggle.value, isTrue);
    });

    testWidgets('toggling switch calls onThemeModeChanged with light then dark',
        (WidgetTester tester) async {
      final List<ThemeMode> recordedModes = [];

      await tester.pumpWidget(
        MaterialApp(
          home: SettingsView(
            themeMode: ThemeMode.dark,
            onThemeModeChanged: recordedModes.add,
          ),
        ),
      );

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(recordedModes, [ThemeMode.light]);
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isFalse,
      );

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(recordedModes, [ThemeMode.light, ThemeMode.dark]);
      expect(
        tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
        isTrue,
      );
    });

    testWidgets('shows switch off when initialized with ThemeMode.light',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SettingsView(themeMode: ThemeMode.light),
        ),
      );

      final SwitchListTile toggle =
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(toggle.value, isFalse);
    });
  });
}
