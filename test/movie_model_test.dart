import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('Constructor assigns properties correctly', () {
      const movie = Movie(
        id: 'test_1',
        title: 'Jonny Test',
        ageRating: '12A',
        synopsis: 'A great series.',
        screeningTime: '19:00',
        imagePath: 'assets/test.jpg',
        price: 5.50,
      );

      expect(movie.title, 'Test Film');
      expect(movie.price, 5.50);
      expect(movie.id, 'test_1');
    });

    test('formattedPrice formats with £ and two decimal places', () {
      // Check a price with pence
      const movieWithPence = Movie(
        id: 'test_2',
        title: 'Penny Film',
        ageRating: 'X',
        synopsis: '...',
        screeningTime: '...',
        imagePath: '...',
        price: 7.50,
      );

      expect(movieWithPence.formattedPrice, '£7.50');

      const movieWholePound = Movie(
        id: 'test_3',
        title: 'jellof united',
        ageRating: 'X',
        synopsis: '...',
        screeningTime: '...',
        imagePath: '...',
        price: 8.0,
      );

      expect(movieWholePound.formattedPrice, '£8.00');
    });
  });
}
