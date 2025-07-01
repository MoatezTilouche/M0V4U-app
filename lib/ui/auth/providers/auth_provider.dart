import 'package:app_m0v4u/services/auth_service.dart';
import 'package:app_m0v4u/ui/auth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final TMDBAuthService _authService = TMDBAuthService();

  String? _requestToken;
  String? _sessionId;
  TMDBUser? _user;
  bool isLoading = false;

  String? get requestToken => _requestToken;
  String? get sessionId => _sessionId;
  TMDBUser? get user => _user;
  bool get isLoggedIn => _sessionId != null && _user != null;

  AuthProvider() {
    _loadSavedSession();
  }

  // Load saved session from SharedPreferences
  Future<void> _loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSessionId = prefs.getString('session_id');
    final savedUserJson = prefs.getString('user_json');

    if (savedSessionId != null && savedUserJson != null) {
      try {
        isLoading = true;
        notifyListeners();

        // Validate session by fetching user details
        final user = await _authService.getUserDetails(savedSessionId);
        if (user != null) {
          _sessionId = savedSessionId;
          _user = user;
        } else {
          // Clear invalid session
          await prefs.remove('session_id');
          await prefs.remove('user_json');
        }
      } catch (e) {
        print("❌ Failed to validate saved session: $e");
        await prefs.remove('session_id');
        await prefs.remove('user_json');
      } finally {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // Save session to SharedPreferences
  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_sessionId != null) {
      await prefs.setString('session_id', _sessionId!);
    }
    if (_user != null) {
      await prefs.setString('user_json', jsonEncode(_user!.toJson()));
    }
  }

  Future<void> startLoginProcess(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    _requestToken = await _authService.createRequestToken();
    if (_requestToken != null) {
      final success = await _authService.launchBrowserToApprove(_requestToken!);
      if (!success) {
        _showError(context, "Failed to open approval page.");
      }
    } else {
      _showError(context, "Failed to create request token.");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<String?> createSessionAfterApproval() async {
    if (_requestToken == null) return null;

    isLoading = true;
    notifyListeners();

    try {
      _sessionId = await _authService.createSession(_requestToken!);
      if (_sessionId != null) {
        _user = await _authService.getUserDetails(_sessionId!);
        if (_user != null) {
          await _saveSession(); // Save session and user to SharedPreferences
          notifyListeners();
          return _sessionId;
        } else {
          _showError(null, "Failed to fetch user details.");
        }
      }
    } catch (e) {
      print("❌ createSessionAfterApproval: $e");
      _showError(null, "Failed to create session.");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_id');
    await prefs.remove('user_json');
    _requestToken = null;
    _sessionId = null;
    _user = null;
    notifyListeners();
  }

  void _showError(BuildContext? context, String msg) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}