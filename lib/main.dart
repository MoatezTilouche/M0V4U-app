// lib/main.dart
import 'package:app_m0v4u/pages/navbar/customNavbar.dart';
import 'package:app_m0v4u/pages/navbar/menuDrawer.dart';
import 'package:app_m0v4u/pages/navbar/navbarProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavBarState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M0V4U',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavBar(),
      drawer: const MenuDrawer(),
      body: Consumer<NavBarState>(
        builder: (context, navState, child) {
          return Center(
            child: Text(
              navState.isSearchActive
                  ? 'Searching for: ${navState.searchQuery}'
                  : 'Home Content',
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          );
        },
      ),
    );
  }
}