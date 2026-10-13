import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../constants.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: const Color(0xFF1A1A24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Image.asset(
              movie.imagePath,
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${movie.title} (${movie.ageRating})',
                    style: const TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent, 
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.synopsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    movie.screeningTime,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: const Text('BOOK NOW'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}