import '../models/movie.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MovieRepository {
  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return cachedMovies;
    }

   return [
      const Movie(
        id: 'silo',
        title: 'SILO',
        ageRating: '15',
        synopsis: 'In a ruined and toxic future, a community exists in a giant underground silo.',
        screeningTime: 'Friday 16 Oct 2026 19:00',
        imagePath: 'assets/images/silo.jpg',
        price: 7.50,
      ),
      const Movie(
        id: 'severance',
        title: 'SEVERANCE',
        ageRating: '15',
        synopsis: 'Mark leads a team of office workers whose memories have been surgically divided.',
        screeningTime: 'Saturday 17 Oct 2026 20:00',
        imagePath: 'assets/images/severance.jpg',
        price: 8.00,
      ),
    ];
  }

  Movie? getMovieById(String id) {
    final List<Movie> allMovies = getMovies();

    for (final movie in allMovies) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  List<Movie>? _cachedMovies;

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    
    final dynamic decodedData = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedData as List<dynamic>;
    
    final List<Movie> loadedMovies = [];
    for (final dynamic item in jsonList) {
      final Map<String, dynamic> itemMap = item as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(itemMap);
      loadedMovies.add(movie);
    }

    _cachedMovies = loadedMovies;
    return loadedMovies;
  }
}
