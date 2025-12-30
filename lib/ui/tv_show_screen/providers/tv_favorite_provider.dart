import 'package:flutter/material.dart';
import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';

class TvFavoriteProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _favorites = [];
  List<Map<String, dynamic>> _recommendations = [];

  bool _isLoading = false;
  bool _isLoadingRecommendations = false;

  String? _error;

  List<Map<String, dynamic>> get favorites => _favorites;
  List<Map<String, dynamic>> get recommendations => _recommendations;
  bool get isLoading => _isLoading;
  bool get isLoadingRecommendations => _isLoadingRecommendations;
  String? get error => _error;

  TvFavoriteProvider({UserService? userService})
      : _userService = userService ?? UserService();

  Future<void> fetchTvFavorites(AuthProvider auth) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    _setLoading(true);
    try {
      final result = await _userService.getFavoriteTvShows(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
      );
      _favorites = result.cast<Map<String, dynamic>>();
      _setError(null);
    } catch (e) {
      _setError('Failed to load TV favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTvFavorite({
    required AuthProvider auth,
    required int tvShowId,
    required bool add,
  }) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    try {
      final success = await _userService.addTvShowToFavorite(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
        tvShowId: tvShowId,
        favorite: add,
      );
      if (success) {
        await fetchTvFavorites(auth);
      } else {
        _setError('Failed to update TV favorites');
      }
    } catch (e) {
      _setError('Failed to update TV favorites: $e');
    }
  }

  bool isInFavorites(int tvShowId) {
    return _favorites.any((tv) => tv['id'] == tvShowId);
  }

  /// Load recommended TV shows based on favorite TV shows
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
        final similar = await _userService.getSimilarTvShows(fav['id']);
        recommended.addAll(similar);
      }

      // Remove duplicates by TV show ID
      _recommendations = {
        for (var item in recommended) item['id']: item
      }.values.toList();

    } catch (e) {
      print("Error fetching TV show recommendations: $e");
      _recommendations = [];
      _setError('Failed to load TV show recommendations: $e');
    } finally {
      _isLoadingRecommendations = false;
      notifyListeners();
    }
  }

  void clearFavorites() {
    _favorites = [];
    _recommendations = [];
    _error = null;
    _isLoading = false;
    _isLoadingRecommendations = false;
    notifyListeners();
  }

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