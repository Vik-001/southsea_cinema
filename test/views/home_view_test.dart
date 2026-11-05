import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:southsea_cinema/views/home_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    rootBundle.clear();
  });

  group('HomeView UI Tests', () {
    testWidgets('displays movies loaded from JSON asset', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeView()));
      await tester.pumpAndSettle();

      expect(find.textContaining('SILO'), findsWidgets);
      expect(find.textContaining('SEVERANCE'), findsWidgets);
    });
  });
}