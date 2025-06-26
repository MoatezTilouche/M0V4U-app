import 'package:flutter/material.dart';

import '../../../services/actor_service.dart';
import '../../actor/models/actor.dart';


class ActorsProvider with ChangeNotifier {
  final ActorService _actorService = ActorService();

  List<Actor> popularActors = [];
  List<Actor> searchResults = [];
  bool isLoading = false;
  int currentPopularPage = 1;
  int currentSearchPage = 1;
  bool popularHasMorePages = true;
  bool searchHasMorePages = true;
  String searchQuery = '';
  String? errorMessage;

  Future<void> fetchPopularActors() async {
    if (!popularHasMorePages || isLoading) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final actors = await _actorService.getPopularActors(currentPopularPage);
      popularActors.addAll(actors);
      currentPopularPage++;
      popularHasMorePages = actors.isNotEmpty;
      print(actors.length);
    } catch (e) {
      errorMessage = 'Failed to load popular actors: $e';
      print(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> searchActors(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      searchQuery = '';
      notifyListeners();
      return;
    }

    if (query != searchQuery) {
      searchResults.clear();
      currentSearchPage = 1;
      searchHasMorePages = true;
      searchQuery = query;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final actors = await _actorService.searchActors(query, currentSearchPage);
      searchResults.addAll(actors);
      currentSearchPage++;
      searchHasMorePages = actors.isNotEmpty;

    } catch (e) {
      errorMessage = 'Failed to search actors: $e';
      print(errorMessage);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void resetActors(int tabIndex) {
    switch (tabIndex) {
      case 0:
        popularActors.clear();
        currentPopularPage = 1;
        popularHasMorePages = true;
        break;
      case 1:
        searchResults.clear();
        currentSearchPage = 1;
        searchHasMorePages = true;
        searchQuery = '';
        break;
    }
    isLoading = false;
    errorMessage = null;
    notifyListeners();
  }

  bool hasMorePages(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return popularHasMorePages;
      case 1:
        return searchHasMorePages;
      default:
        return false;
    }
  }
}