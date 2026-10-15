import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('Movie Repository Tests', () {
    
    test('getMovies returns the correct list of films', () {
      final repository = MovieRepository();
      final movies = repository.getMovies();
      
      expect(movies.length, 2); 
      expect(movies[0].id, 'silo');
      expect(movies[1].id, 'severance');
    });

    test('getMovieById returns the correct movie when ID exists', () {
      final repository = MovieRepository();
      final movie = repository.getMovieById('silo');
      
      expect(movie, isNotNull); 
      expect(movie?.title, 'SILO'); 
    });

    test('getMovieById returns null when ID does not exist', () {
      final repository = MovieRepository();
      final movie = repository.getMovieById('spiderman'); // This ID doesn't exist
      
      expect(movie, isNull); 
    });

  });
}