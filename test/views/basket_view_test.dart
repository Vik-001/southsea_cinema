import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';

const Movie testMovie = Movie(
  id: 'film_slow_horses',
  title: 'Slow Horses: Special Screening',
  ageRating: '15',
  synopsis: 'A dysfunctional team of British MI5 agents navigate the espionage world.',
  screeningTime: '20:00',
  imagePath: 'assets/images/slow_horses.jpg',
  price: 6.0, 
);

void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketView UI Tests', () {
    
    testWidgets('shows empty message and zero totals when basket is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text('YOUR BASKET IS EMPTY!'), findsOneWidget);
      
      expect(find.text('£0.00'), findsNothing); 
    });

    testWidgets('displays tickets and removes them when delete is tapped', (WidgetTester tester) async {
      BasketRepository.instance.addItem(const TicketItem(
        movie: testMovie,
        quantity: 2,
      ));

      await tester.pumpWidget(const MaterialApp(home: BasketView()));

      expect(find.text('Slow Horses: Special Screening'), findsOneWidget);
      expect(find.text('2 x £6.00'), findsOneWidget);
      
      expect(find.text('£12.00'), findsOneWidget); 

      await tester.tap(find.byIcon(Icons.delete));
      
      await tester.pumpAndSettle(); 

      expect(find.text('Slow Horses: Special Screening'), findsNothing);
      expect(find.text('YOUR BASKET IS EMPTY!'), findsOneWidget);
    });
    
  });
}