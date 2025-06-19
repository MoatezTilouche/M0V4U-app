import 'package:app_m0v4u/services/movies_service.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import 'package:flutter/material.dart';

class MoviesProvider with ChangeNotifier {
  final MoviesService _moviesService = MoviesService();

  List<Result> popularMovies = [];
  List<Result> upcomingMovies = [];
  List<Result> topRatedMovies = [];
  List<Result> nowPlayingMovies = [];

  bool isLoading = false;
  int currentPopularPage = 1;
  int currentUpcomingPage = 1;
  int currentTopRatedPage = 1;
  int currentNowPlayingPage = 1;

  bool popularHasMorePages = true;
  bool upcomingHasMorePages = true;
  bool topRatedHasMorePages = true;
  bool nowPlayingHasMorePages = true;

  Future<void> fetchPopularMovies() async {
    if (!popularHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies = await _moviesService.getPopularMovies(currentPopularPage);
      popularMovies.addAll(movies);
      currentPopularPage++;
      popularHasMorePages = movies.isNotEmpty; // Adjust based on API response
    } catch (e) {
      print('Error fetching popular movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingMovies() async {
    if (!upcomingHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies = await _moviesService.getUpcomingMovies(currentUpcomingPage);
      upcomingMovies.addAll(movies);
      currentUpcomingPage++;
      upcomingHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching upcoming movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    if (!topRatedHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies = await _moviesService.getTopRatedMovies(currentTopRatedPage);
      topRatedMovies.addAll(movies);
      currentTopRatedPage++;
      topRatedHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching top-rated movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNowPlayingMovies() async {
    if (!nowPlayingHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies =
          await _moviesService.getNowPlayingMovies(currentNowPlayingPage);
      nowPlayingMovies.addAll(movies);
      currentNowPlayingPage++;
      nowPlayingHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching now playing movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void resetMovies(int tabIndex) {
    switch (tabIndex) {
      case 0:
        popularMovies.clear();
        currentPopularPage = 1;
        popularHasMorePages = true;
        break;
      case 1:
        upcomingMovies.clear();
        currentUpcomingPage = 1;
        upcomingHasMorePages = true;
        break;
      case 2:
        topRatedMovies.clear();
        currentTopRatedPage = 1;
        topRatedHasMorePages = true;
        break;
      case 3:
        nowPlayingMovies.clear();
        currentNowPlayingPage = 1;
        nowPlayingHasMorePages = true;
        break;
    }
    isLoading = false;
    notifyListeners();
  }

  bool hasMorePages(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return popularHasMorePages;
      case 1:
        return upcomingHasMorePages;
      case 2:
        return topRatedHasMorePages;
      case 3:
        return nowPlayingHasMorePages;
      default:
        return false;
    }
  }
}