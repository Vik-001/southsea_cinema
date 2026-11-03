import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';


const Movie testMovie = Movie(
  id: 'film_slow_horses',
  title: 'Slow Horses',
  ageRating: '18',
  synopsis: 'A dysfunctional team of British MI5 agents navigate the espionage world.',
  screeningTime: '20:00',
  imagePath: 'assets/images/slow_horses.jpg',
  price: 6.0,
);

void main() {
  setUp(() {
    BasketRepository.instance.clear();
  });

  group('BasketRepository tests', () {
    
    test('starts with empty basket and zero totals', () {
      final basket = BasketRepository.instance;
      
      expect(basket.getItems().length, 0);
      expect(basket.getSubtotal(), 0.0);
      expect(basket.getServiceCharge(), 0.0);
      expect(basket.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal and service charge correctly', () {
      final basket = BasketRepository.instance;
      
      const TicketItem item = TicketItem(
        movie: testMovie,
        quantity: 2,
      );
      
      basket.addItem(item);
      
      expect(basket.getItems().length, 1);
      expect(basket.getSubtotal(), 12.0);
      expect(basket.getServiceCharge(), 4.0);
      expect(basket.getTotalDue(), 16.0); 
    });

    test('removes items correctly', () {
      final basket = BasketRepository.instance;
      const TicketItem item = TicketItem(movie: testMovie, quantity: 1);
      
      basket.addItem(item);
      expect(basket.getItems().length, 1); 
      
      basket.removeItem(0);
      
      expect(basket.getItems().length, 0);
      expect(basket.getTotalDue(), 0.0);
    });
    
  });
}