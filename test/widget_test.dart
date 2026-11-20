import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  setUp(() {
    rootBundle.clear();
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
  }

  testWidgets('Home page displays title, movie cards, and booking buttons',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('SOUTHSEA CINEMA'), findsOneWidget);

    expect(find.textContaining('SILO'), findsAtLeastNWidgets(1));
    expect(find.textContaining('SEVERANCE'), findsAtLeastNWidgets(1));

    expect(find.text('BOOK NOW'), findsNWidgets(2));
  });

  testWidgets('Navigates to listing and tap Add to order',
      (WidgetTester tester) async {
    await pumpApp(tester);

    final firstBookButton = find.text('BOOK NOW').first;
    await tester.tap(firstBookButton);

    await tester.pumpAndSettle();

    expect(find.text('ADD TO ORDER'), findsOneWidget);

    final orderButton = find.text('ADD TO ORDER');
    await tester.ensureVisible(orderButton);
    await tester.tap(orderButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Successfully added to your basket!'),
        findsOneWidget);
  });
}
