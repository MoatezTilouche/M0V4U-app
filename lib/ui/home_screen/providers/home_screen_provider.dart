import 'package:app_m0v4u/services/home_services.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart' hide Movie;
import 'package:flutter/material.dart';

class HomeScreenProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();


  List<Movie> popularMovies = [];
  List<Movie> searchResults = [];
  List<Actor> popularActors =[];

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

   Future<void> fetchPopularActors() async {
    isLoading = true;
    try {
      final actors = await _movieService
          .getPopularActors(); 
      popularActors = actors;
    } catch (e) {
      print('Error fetching popular actors: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  Future<void> searchMovies(String query) async {
    searchQuery = query;
    isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      searchResults.clear();
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final results =
          await _movieService.searchMovies(query); // Call search API
      searchResults = results;
      print(results);
      
    } catch (e) {
      print('Error searching movies: $e');
      searchResults.clear();
    }

    isLoading = false;
    notifyListeners(); // Update UI with search results
  }

}
