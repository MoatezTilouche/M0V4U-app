import 'package:app_m0v4u/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';

class HomeScreenProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<Movie> popularMovies = [];
  String searchQuery = '';
  bool isLoading = false;

  // Fetch popular movies
  Future<void> fetchPopularMovies() async {
    isLoading = true;
    try {
      final movies = await _movieService
          .getPopularMovies(); // Fetch movies from the service
      popularMovies = movies;
    } catch (e) {
      print('Error fetching popular movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }
}
