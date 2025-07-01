import 'package:flutter/material.dart';

import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';


/// Manages the user's favorite movies list, interacting with the TMDB API via UserService.
class FavoriteProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;
  String? _error;

  /// List of favorite movies, each represented as a map with TMDB movie details.
  List<Map<String, dynamic>> get favorites => _favorites;

  bool get isLoading => _isLoading;

  String? get error => _error;

  FavoriteProvider({UserService? userService}) : _userService = userService ?? UserService();


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
      _favorites = result.cast<Map<String, dynamic>>(); // Cast to fix type mismatch
      _setError(null);
    } catch (e) {
      _setError('Failed to load favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Adds or removes a movie from the user's favorites.
  /// [add] determines whether to add (true) or remove (false) the movie.
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
        await fetchFavorites(auth); // Refresh the favorites list
      } else {
        _setError('Failed to update favorites');
      }
    } catch (e) {
      _setError('Failed to update favorites: $e');
    }
  }

  /// Checks if a movie is in the favorites list by its [movieId].
  bool isInFavorites(int movieId) {
    return _favorites.any((movie) => movie['id'] == movieId);
  }

  /// Clears the favorites list, typically used on logout.
  void clearFavorites() {
    _favorites = [];
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Checks if the user is authenticated with a valid user and session ID.
  bool _isUserAuthenticated(AuthProvider auth) {
    return auth.user != null && auth.sessionId != null;
  }

  /// Sets the loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sets the error message and notifies listeners.
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }
}