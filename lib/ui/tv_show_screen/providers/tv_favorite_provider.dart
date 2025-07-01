import 'package:flutter/material.dart';
import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';

class TvFavoriteProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get favorites => _favorites;
  bool get isLoading => _isLoading;
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

  void clearFavorites() {
    _favorites = [];
    _error = null;
    _isLoading = false;
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
