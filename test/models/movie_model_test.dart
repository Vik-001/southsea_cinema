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

      expect(movie.title, 'Jonny Test');
      expect(movie.price, 5.50);
      expect(movie.id, 'test_1');
    });

    test('formattedPrice formats with £ and two decimal places', () {
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
    });

    test('JSON conversion preserves every movie field', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'film_dune',
        'title': 'Dune: Part Two',
        'ageRating': '12A',
        'synopsis': 'Paul Atreides unites with Chani and the Fremen.',
        'screeningTime': '19:00',
        'imagePath': 'assets/images/dune.jpg',
        'price': 8.50,
      };

      final Movie movie = Movie.fromJson(data);

      expect(movie.id, 'film_dune');
      expect(movie.title, 'Dune: Part Two');
      expect(movie.ageRating, '12A');
      expect(movie.synopsis, 'Paul Atreides unites with Chani and the Fremen.');
      expect(movie.screeningTime, '19:00');
      expect(movie.imagePath, 'assets/images/dune.jpg');
      expect(movie.price, 8.50);

      expect(movie.toJson(), data);
    });

    test('fromJson accepts a whole-number price', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'film_test',
        'title': 'Test Movie',
        'ageRating': 'U',
        'synopsis': 'A test movie.',
        'screeningTime': '12:00',
        'imagePath': 'assets/images/test.jpg',
        'price': 8,
      };

      final Movie movie = Movie.fromJson(data);
      expect(movie.price, 8.0);
      expect(movie.price, isA<double>());
    });

    test('formattedPrice handles whole pounds without decimals', () {
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
