import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navbarProvider.dart'; // Import the provider for NavBarState

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomNavBarState extends State<CustomNavBar> {
  late final NavBarState navState;

  @override
  void initState() {
    super.initState();
    navState = context
        .read<NavBarState>(); // Reading the provider for one-time use

    // // Initialize the navState properly
    // navState.toggleMenu();  // Optional, based on your app's logic
    // navState.toggleSearch();  // Optional, based on your app's logic
    // navState.setSearchQuery(''); // Optional, based on your app's logic
    // navState.closeAll();  // Optional, based on your app's logic
  }

  @override
  Widget build(BuildContext context) {
    // Listen to navState using Consumer or context.watch() to rebuild when changes occur
    return Consumer<NavBarState>(
      builder: (context, navState, _) {
        return AppBar(
          backgroundColor: const Color(0xFF112155),
          leading: IconButton(
            icon: Image.asset(
              'assets/menu.png', // Path to your downloaded icon image
              height: 30.0, // Adjust the size of the icon
              width: 30.0, // Adjust the size of the icon
            ),
            onPressed: () {
              navState.toggleMenu();
              Scaffold.of(
                context,
              ).openDrawer(); // Open drawer when menu button is pressed
            },
          ),
          title: navState.isSearchActive
              ? TextField(
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => navState.setSearchQuery(value),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png', // Path to your downloaded icon image
                      height: 24.0, // Adjust the size of the icon
                      width: 24.0, // Adjust the size of the icon
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'M0V4U',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
          actions: [
            IconButton(
              icon: Icon(
                navState.isSearchActive ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (navState.isSearchActive) {
                  navState.setSearchQuery(''); // Clear search query if active
                }
                navState.toggleSearch(); // Toggle search state
              },
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onPressed: () {
                // Handle profile click
              },
            ),
          ],
        );
      },
    );
  }
}
