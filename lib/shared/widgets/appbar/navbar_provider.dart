import 'package:flutter/material.dart';

class NavBarState extends ChangeNotifier {
  bool _isMenuOpen = false;
  bool _isSearchActive = false;
  String _searchQuery = '';

  bool get isMenuOpen => _isMenuOpen;
  bool get isSearchActive => _isSearchActive;
  String get searchQuery => _searchQuery;

  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchActive = !_isSearchActive;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void closeAll() {
    _isMenuOpen = false;
    _isSearchActive = false;
    notifyListeners();
  }
}