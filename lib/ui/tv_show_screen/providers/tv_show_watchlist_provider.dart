import 'package:flutter/material.dart';
import '../../../services/user_services.dart';
import '../../auth/providers/auth_provider.dart';

class TvWatchlistProvider extends ChangeNotifier {
  final UserService _userService;

  List<Map<String, dynamic>> _watchlist = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TvWatchlistProvider({UserService? userService})
      : _userService = userService ?? UserService();

  Future<void> fetchTvWatchlist(AuthProvider auth) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    _setLoading(true);
    try {
      _watchlist = await _userService.getTvWatchlist(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
      );
      _setError(null);
    } catch (e) {
      _setError('Failed to load TV watchlist: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTvWatchlist({
    required AuthProvider auth,
    required int tvShowId,
    required bool add,
  }) async {
    if (!_isUserAuthenticated(auth)) {
      _setError('User or session ID is missing');
      return;
    }

    try {
      final success = await _userService.addTvShowToWatchlist(
        accountId: auth.user!.id,
        sessionId: auth.sessionId!,
        tvShowId: tvShowId,
        watchlist: add,
      );
      if (success) {
        await fetchTvWatchlist(auth);
      } else {
        _setError('Failed to update TV watchlist');
      }
    } catch (e) {
      _setError('Failed to update TV watchlist: $e');
    }
  }

  bool isInWatchlist(int tvShowId) {
    return _watchlist.any((tv) => tv['id'] == tvShowId);
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
