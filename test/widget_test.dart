import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';

void main() {
  testWidgets('Home page displays title, movie cards, and booking buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());

    expect(find.text('Southsea Cinema'), findsOneWidget);

    expect(find.textContaining('SILO'), findsAtLeastNWidgets(1));
    expect(find.textContaining('SEVERANCE'), findsAtLeastNWidgets(1));

    expect(find.text('BOOK NOW'), findsNWidgets(2));
  });

    testWidgets('Navigates to listing and tap Add to order', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      final firstBookButton = find.text('BOOK NOW').first;
      await tester.tap(firstBookButton);

      await tester.pumpAndSettle();

      expect(find.textContaining('underground silo'), findsOneWidget);

      final orderButton = find.text('ADD TO ORDER');
      await tester.ensureVisible(orderButton);
      await tester.tap(orderButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Added'), findsOneWidget); 
    });
}

