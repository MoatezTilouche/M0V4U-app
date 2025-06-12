// lib/widgets/menu_drawer.dart
import 'package:app_m0v4u/shared/widgets/appbar/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavBarState>(context, listen: false);

    return Drawer(
      backgroundColor: Colors.black87,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.red,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'M0V4U',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.movie_filter, color: Colors.white),
            title: const Text('Movies', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.tv, color: Colors.white),
            title: const Text('TV Shows', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}