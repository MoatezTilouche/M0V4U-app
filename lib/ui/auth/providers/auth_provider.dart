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

  // Time-based stats
  DateTime? memberSince;
  DateTime? lastLogin;
  int loginStreak = 1;

  String? get requestToken => _requestToken;
  String? get sessionId => _sessionId;
  TMDBUser? get user => _user;
  bool get isLoggedIn => _sessionId != null && _user != null;

  AuthProvider() {
    _loadSavedSession();
  }

  Future<void> _loadSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSessionId = prefs.getString('session_id');
    final savedUserJson = prefs.getString('user_json');

    if (savedSessionId != null && savedUserJson != null) {
      try {
        isLoading = true;
        notifyListeners();

        final user = await _authService.getUserDetails(savedSessionId);
        if (user != null) {
          _sessionId = savedSessionId;
          _user = user;

          // Load time-based stats
          final memberSinceStr = prefs.getString('member_since');
          final lastLoginStr = prefs.getString('last_login');
          final savedStreak = prefs.getInt('login_streak') ?? 1;

          if (memberSinceStr != null) {
            memberSince = DateTime.tryParse(memberSinceStr);
          }
          if (lastLoginStr != null) {
            lastLogin = DateTime.tryParse(lastLoginStr);
          }

          // Calculate streak
          final today = DateTime.now();
          if (lastLogin != null) {
            final diff = today.difference(lastLogin!).inDays;
            if (diff == 1) {
              loginStreak = savedStreak + 1;
            } else if (diff > 1) {
              loginStreak = 1;
            } else {
              loginStreak = savedStreak;
            }
          } else {
            loginStreak = 1;
          }

          // Save streak and last login
          await prefs.setInt('login_streak', loginStreak);
          await prefs.setString('last_login', today.toIso8601String());
        } else {
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

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (_sessionId != null) {
      await prefs.setString('session_id', _sessionId!);
    }
    if (_user != null) {
      await prefs.setString('user_json', jsonEncode(_user!.toJson()));
    }

    // Save time-based stats
    final today = DateTime.now();
    await prefs.setString('last_login', today.toIso8601String());

    if (memberSince == null) {
      memberSince = today;
      await prefs.setString('member_since', today.toIso8601String());
    }

    await prefs.setInt('login_streak', loginStreak);
  }

  Future<void> startLoginProcess(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      _requestToken = await _authService.createRequestToken();
      if (_requestToken != null) {
        final success = await _authService.launchBrowserToApprove(_requestToken!);
        if (!success) {
          _showError(context, "Failed to open approval page.");
        }
      } else {
        _showError(context, "Failed to create request token.");
      }
    } catch (e) {
      _showError(context, "Failed to start login: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
          loginStreak = 1; // First login of streak
          memberSince ??= DateTime.now();
          await _saveSession();
          notifyListeners();
          return _sessionId;
        } else {
          _showError(null, "Failed to fetch user details.");
        }
      } else {
        _showError(null, "Failed to create session.");
      }
    } catch (e) {
      print("❌ createSessionAfterApproval: $e");
      _showError(null, "Failed to create session: $e");
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
    await prefs.remove('last_login');
    await prefs.remove('login_streak');
    await prefs.remove('member_since');
    _requestToken = null;
    _sessionId = null;
    _user = null;
    memberSince = null;
    lastLogin = null;
    loginStreak = 1;
    notifyListeners();
  }

  void _showError(BuildContext? context, String msg) {
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}