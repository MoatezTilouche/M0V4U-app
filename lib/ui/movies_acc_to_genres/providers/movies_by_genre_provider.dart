import 'package:flutter/material.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import '../../../services/movies_acc_to_genres.dart';

class GenreMoviesProvider with ChangeNotifier {
  final GenreMoviesService _genreMoviesService = GenreMoviesService();

  List<Result> genreMovies = [];
  bool isLoading = false;
  int currentPage = 1;
  bool hasMorePages = true;

  // Method to fetch movies by genre
  Future<void> fetchMoviesByGenre(int genreId) async {
    if (!hasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners(); // Notify the UI to show loading state

    try {
      final movies = await _genreMoviesService.getMoviesByGenre(genreId, currentPage);

      if (movies.isNotEmpty) {
        genreMovies.addAll(movies);
        currentPage++;


        hasMorePages = movies.length >0;
      } else {
        hasMorePages = false;
      }
    } catch (e) {
      print('Error fetching movies by genre: $e');
      hasMorePages = false;
    }

    isLoading = false;
    notifyListeners(); // Notify the UI to stop showing loading state
  }

  // Method to reset the data when switching genres or refreshing the page
  void resetGenreMovies(int genreId) {
    genreMovies.clear();
    currentPage = 1;
    hasMorePages = true;
    fetchMoviesByGenre(genreId);
    notifyListeners(); // Notify the UI that data has been reset
  }

  // Method to check if there are more pages available for fetching
  bool hasMorePagesForGenre() {
    return hasMorePages;
  }
}
