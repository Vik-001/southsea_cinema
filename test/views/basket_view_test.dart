import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const Movie testMovie = Movie(
  id: 'film_slow_horses',
  title: 'Slow Horses: Special Screening',
  ageRating: '15',
  synopsis:
      'A dysfunctional team of British MI5 agents navigate the espionage world.',
  screeningTime: '20:00',
  imagePath: 'assets/images/slow_horses.jpg',
  price: 6.0,
);

void main() {
  late Database testDatabase;

  setUp(() async {
    BasketRepository.instance.clear();
    sqfliteFfiInit();
    testDatabase = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );
    CinemaDatabase.instance.setDatabase(testDatabase);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
    BasketRepository.instance.clear();
  });

  Future<void> pumpBasketView(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BasketView()));
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
  }

  group('BasketView UI Tests', () {
    testWidgets('shows empty message and zero totals when basket is empty',
        (WidgetTester tester) async {
      await pumpBasketView(tester);

      expect(find.text('YOUR BASKET IS EMPTY!'), findsOneWidget);
      expect(find.text('£0.00'), findsNothing);
      expect(find.text('No bookings yet'), findsOneWidget);
    });

    testWidgets('displays tickets and removes them when delete is tapped',
        (WidgetTester tester) async {
      BasketRepository.instance.addItem(
        const TicketItem(movie: testMovie, quantity: 2),
      );

      await pumpBasketView(tester);

      expect(find.text('Slow Horses: Special Screening'), findsOneWidget);
      expect(find.text('2 x £6.00'), findsOneWidget);
      expect(find.text('£12.00'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Slow Horses: Special Screening'), findsNothing);
      expect(find.text('YOUR BASKET IS EMPTY!'), findsOneWidget);
    });
  });

  group('BasketView SQLite Persistence Tests', () {
    testWidgets(
        'checkout saves the booking, clears the basket, and displays it',
        (WidgetTester tester) async {
      BasketRepository.instance.addItem(
        const TicketItem(movie: testMovie, quantity: 2),
      );

      await pumpBasketView(tester);

      final Finder checkoutButton = find.text('CHECKOUT');
      await tester.ensureVisible(checkoutButton);
      await tester.tap(checkoutButton);
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      expect(BasketRepository.instance.getItems(), isEmpty);
      expect(find.text('YOUR BASKET IS EMPTY!'), findsOneWidget);
      expect(find.text('Booking #1001 saved'), findsOneWidget);
      expect(find.text('Booking #1001'), findsOneWidget);
      expect(find.text('2 x Slow Horses: Special Screening'), findsOneWidget);
      expect(find.text('£16.00'), findsOneWidget);

      final List<Booking>? savedBookings = await tester.runAsync(
        () => CinemaDatabase.instance.getAllBookings(),
      );
      expect(savedBookings, isNotNull);
      expect(savedBookings!.length, 1);
      expect(savedBookings[0].bookingNumber, 1001);
      expect(savedBookings[0].summary, '2 x Slow Horses: Special Screening');
      expect(savedBookings[0].total, 16.00);
    });

    testWidgets('checkout keeps the basket when saving to SQLite fails',
        (WidgetTester tester) async {
      BasketRepository.instance.addItem(
        const TicketItem(movie: testMovie, quantity: 2),
      );

      await pumpBasketView(tester);

      await tester.runAsync(() async {
        await testDatabase.execute('DROP TABLE bookings');
      });

      final Finder checkoutButton = find.text('CHECKOUT');
      await tester.ensureVisible(checkoutButton);
      await tester.tap(checkoutButton);
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle();

      expect(BasketRepository.instance.getItems().length, 1);
      expect(find.text('Slow Horses: Special Screening'), findsOneWidget);
      expect(
          find.textContaining('Could not save your booking'), findsOneWidget);
    });

    testWidgets('past bookings appear with the newest booking first',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await CinemaDatabase.instance.insertBooking(
          const Booking(
            bookingNumber: 1001,
            summary: '1 x Slow Horses: Special Screening',
            total: 10.00,
            date: '01/01/2026 10:00',
          ),
        );
        await CinemaDatabase.instance.insertBooking(
          const Booking(
            bookingNumber: 1002,
            summary: '2 x Slow Horses: Special Screening',
            total: 16.00,
            date: '02/01/2026 14:30',
          ),
        );
      });

      await pumpBasketView(tester);

      final Finder olderBooking = find.text('Booking #1001');
      final Finder newerBooking = find.text('Booking #1002');

      expect(olderBooking, findsOneWidget);
      expect(newerBooking, findsOneWidget);

      expect(
        tester.getTopLeft(newerBooking).dy,
        lessThan(tester.getTopLeft(olderBooking).dy),
      );
    });
  });
}
