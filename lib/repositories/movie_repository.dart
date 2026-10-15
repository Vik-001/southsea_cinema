import '../models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'silo',
        title: 'SILO',
        ageRating: '15',
        synopsis: 'In a ruined and toxic future, a community exists in a giant underground silo that plunges hundreds of stories deep.',
        screeningTime: 'Friday 16 Oct 2026 19:00',
        imagePath: 'assets/images/silo.jpg',
        price: 7.50,
      ),
      const Movie(
        id: 'severance',
        title: 'SEVERANCE',
        ageRating: '15',
        synopsis: 'Mark leads a team of office workers whose memories have been surgically divided between their work and personal lives.',
        screeningTime: 'Saturday 17 Oct 2026 20:00',
        imagePath: 'assets/images/severance.jpg',
        price: 8.00,
      ),
    ];
  }
}