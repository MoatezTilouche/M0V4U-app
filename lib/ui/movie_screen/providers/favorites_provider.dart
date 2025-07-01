import 'package:flutter/material.dart';

import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';


import 'package:flutter/material.dart';
import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';

class FavoriteProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = false;
  bool _isLoadingRecommendations = false;
  String? _error;

  /// Expose favorites
  List<Map<String, dynamic>> get favorites => _favorites;

  /// Expose recommendations
  List<Map<String, dynamic>> get recommendations => _recommendations;

  bool get isLoading => _isLoading;
  bool get isLoadingRecommendations => _isLoadingRecommendations;

  String? get error => _error;

  FavoriteProvider({UserService? userService})
      : _userService = userService ?? UserService();

  Future<void> fetchFavorites(AuthProvider auth) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    _setLoading(true);
    try {
      final result = await _userService.getFavoriteMovies(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
      );
      _favorites = result.cast<Map<String, dynamic>>();
      _setError(null);
    } catch (e) {
      _setError('Failed to load favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds or removes a movie from favorites
  Future<void> toggleFavorite({
    required AuthProvider auth,
    required int movieId,
    required bool add,
  }) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    try {
      final success = await _userService.addToFavorite(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
        movieId: movieId,
        favorite: add,
      );

      if (success) {
        await fetchFavorites(auth);
      } else {
        _setError('Failed to update favorites');
      }
    } catch (e) {
      _setError('Failed to update favorites: $e');
    }
  }

  /// Check if movie is in favorites
  bool isInFavorites(int movieId) {
    return _favorites.any((movie) => movie['id'] == movieId);
  }

  /// Load recommended movies based on favorite movies
  Future<void> fetchRecommendations() async {
    if (_favorites.isEmpty) {
      _recommendations = [];
      notifyListeners();
      return;
    }

    _isLoadingRecommendations = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> recommended = [];

      for (final fav in _favorites.take(3)) {
        final similar = await _userService.getSimilarMovies(fav['id']);
        recommended.addAll(similar);
      }

      // remove duplicates by movie ID
      _recommendations = {
        for (var item in recommended) item['id']: item
      }.values.toList();

    } catch (e) {
      print("Error fetching recommendations: $e");
      _recommendations = [];
    } finally {
      _isLoadingRecommendations = false;
      notifyListeners();
    }
  }

  /// Clear
  void clearFavorites() {
    _favorites = [];
    _recommendations = [];
    _error = null;
    _isLoading = false;
    _isLoadingRecommendations = false;
    notifyListeners();
  }

  /// Validate auth
  bool _isUserAuthenticated(AuthProvider auth) {
    return auth.user != null && auth.sessionId != null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }
}
