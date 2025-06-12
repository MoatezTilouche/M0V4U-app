// import 'package:flutter/material.dart';
// import 'test_service.dart';
// import 'model.dart';

// class MovieProvider with ChangeNotifier {
//   final TMDBService _tmdbService = TMDBService();
//   List<Movie> _movies = [];
//   bool _isLoading = false;

//   List<Movie> get movies => _movies;
//   bool get isLoading => _isLoading;

//   // Modify this to ensure notifyListeners is called after the build phase
//   Future<void> loadPopularMovies() async {
//     if (_isLoading) return; // Prevent duplicate fetches
//     _isLoading = true;

//     // Add a post-frame callback to notify listeners after the build phase
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       notifyListeners(); // Notify listeners when loading starts
//     });

//     try {
//       print('Loading movies...');
//       List<Movie> fetchedMovies = await _tmdbService.getPopularMovies();
//       print('Movies loaded: ${fetchedMovies.length}');
//       _movies = fetchedMovies;
//     } catch (e) {
//       _movies = [];
//       print('Error: $e');
//     }

//     _isLoading = false;
//     print('Loading complete.');

//     // Again, notify listeners after loading is complete
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       notifyListeners(); // Notify listeners when loading is complete
//     });
//   }
// }
