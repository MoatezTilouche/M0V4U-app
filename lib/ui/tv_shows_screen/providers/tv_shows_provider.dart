import 'package:app_m0v4u/services/tv_shows_service.dart';
import 'package:flutter/material.dart';

import '../models/tv_shows.dart';

class TvShowsProvider with ChangeNotifier {
  final TvShowsService _moviesService = TvShowsService();

  List<Result> popularTvShows = [];
  List<Result> upcomingTvShows = [];
  List<Result> topRatedTvShows = [];
  List<Result> nowPlayingTvShows = [];

  bool isLoading = false;
  int currentPopularPage = 1;
  int currentUpcomingPage = 1;
  int currentTopRatedPage = 1;
  int currentNowPlayingPage = 1;
  int currentSearchPage = 1; // For search pagination

  bool popularHasMorePages = true;
  bool upcomingHasMorePages = true;
  bool topRatedHasMorePages = true;
  bool nowPlayingHasMorePages = true;
  List<Result> searchResults = []; // To store the search results
  bool searchHasMorePages = true; // For search pagination

  String searchQuery = '';


  Future<void> fetchPopularTvShows() async {
    if (!popularHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final tvShows = await _moviesService.getPopularTvShows(currentPopularPage);
      popularTvShows.addAll(tvShows);
      currentPopularPage++;
      popularHasMorePages = tvShows.isNotEmpty; // Adjust based on API response
    } catch (e) {
      print('Error fetching popular movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUpcomingTvShows() async {
    if (!upcomingHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies = await _moviesService.getUpcomingTvShows(currentUpcomingPage);
      upcomingTvShows.addAll(movies);
      currentUpcomingPage++;
      upcomingHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching upcoming tv shows: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTopRatedTvShows() async {
    if (!topRatedHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies = await _moviesService.getTopRatedTvShows(currentTopRatedPage);
      topRatedTvShows.addAll(movies);
      currentTopRatedPage++;
      topRatedHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching top-rated tv shows: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchNowPlayingTvShows() async {
    if (!nowPlayingHasMorePages || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final movies =
      await _moviesService.getNowPlayingTvShows(currentNowPlayingPage);
      nowPlayingTvShows.addAll(movies);
      currentNowPlayingPage++;
      nowPlayingHasMorePages = movies.isNotEmpty;
    } catch (e) {
      print('Error fetching now playing movies: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  void resetTvShows(int tabIndex) {
    switch (tabIndex) {
      case 0:
        popularTvShows.clear();
        currentPopularPage = 1;
        popularHasMorePages = true;
        break;
      case 1:
        upcomingTvShows.clear();
        currentUpcomingPage = 1;
        upcomingHasMorePages = true;
        break;
      case 2:
        topRatedTvShows.clear();
        currentTopRatedPage = 1;
        topRatedHasMorePages = true;
        break;
      case 3:
        nowPlayingTvShows.clear();
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

// Method to search movies
  Future<void> searchTvShows(String query) async {
    if (query.isEmpty) {
      searchResults = [];  // Clear the search results if query is empty
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final results = await _moviesService.searchTvShows(query, 1);
      searchResults = results;
    } catch (e) {
      print('Error searching movies: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}