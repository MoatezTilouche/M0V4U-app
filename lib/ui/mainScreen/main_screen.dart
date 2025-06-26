import 'package:flutter/material.dart';
import 'package:app_m0v4u/ui/actor_screen/views/actors_screen.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:app_m0v4u/ui/movies/movies_screen/movies_screen.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/bottomBar/bottomBar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the selected tab

  static List<Widget> _screens = <Widget>[
    HomeScreen(),    // Home Screen
    ActorsScreen(),  // Actors Screen
     MoviesScreen(),  // Movies Screen
    const ProfileScreen(), // Profile Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _screens[_selectedIndex],  // Show screen based on selected index

    );
  }
}
