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
}
