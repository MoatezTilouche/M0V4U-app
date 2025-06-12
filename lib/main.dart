import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/shared/widgets/appbar/navbar_provider.dart';
import 'package:app_m0v4u/ui/home_screen/providers/home_screen_provider.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavBarState()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        // Add more providers here
      ],
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
      home: const HomeScreen(),
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
