import 'package:flutter/material.dart';
import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/models/user.dart';

class WatchlistProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _watchlist = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get watchlist => _watchlist;

  bool get isLoading => _isLoading;

  String? get error => _error;

  WatchlistProvider({UserService? userService}) : _userService = userService ?? UserService();

  Future<void> fetchWatchlist(AuthProvider auth) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    _setLoading(true);
    try {
      _watchlist = await _userService.getWatchlist(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
      );
      _setError(null);
    } catch (e) {
      _setError('Failed to load watchlist: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleWatchlist({
    required AuthProvider auth,
    required int movieId,
    required bool add,
  }) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    try {
      final success = await _userService.addToWatchlist(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
        movieId: movieId,
        watchlist: add,
      );

      if (success) {
        await fetchWatchlist(auth); // Refresh the watchlist
      } else {
        _setError('Failed to update watchlist');
      }
    } catch (e) {
      _setError('Failed to update watchlist: $e');
    }
  }

  bool isInWatchlist(int movieId) {
    return _watchlist.any((movie) => movie['id'] == movieId);
  }

  void clearWatchlist() {
    _watchlist = [];
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