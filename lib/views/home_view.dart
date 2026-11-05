import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Movie> _movies = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final repository = MovieRepository();
      final movies = await repository.loadMoviesFromAsset();
      if (!mounted) return;

      setState(() {
        _movies = movies;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Could not load the menu: $error';
        _loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final Widget bodyContent;
    
    if (_loading) {
      bodyContent = const Center(child: CircularProgressIndicator(color: Colors.white));
    } else if (_errorMessage.isNotEmpty) {
      bodyContent = Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent)));
    } else {
      bodyContent = ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: _movies[index]); 
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('SOUTHSEA CINEMA')),
      drawer: const NavDrawer(),
      body: bodyContent,
    );
  }
}