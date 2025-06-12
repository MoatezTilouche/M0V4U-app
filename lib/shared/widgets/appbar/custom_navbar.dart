import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'navbar_provider.dart';

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
    navState = context.read<NavBarState>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarState>(
      builder: (context, navState, _) {
        return AppBar(
          backgroundColor: AppStyles.secondaryColor,
          leading: IconButton(
            icon: Image.asset(
              Assets.menuIcon,
              height: 30.0,
              width: 30.0,
            ),
            onPressed: () {
              navState.toggleMenu();
              Scaffold.of(
                context,
              ).openDrawer();
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
                      Assets.appLogoIcon,
                      height: 24.0,
                      width: 24.0,
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
              icon: Image.asset(
                navState.isSearchActive ? Assets.closeIcon : Assets.searchIcon,
                height: 26.0,
                width: 26.0,
              ),
              onPressed: () {
                if (navState.isSearchActive) {
                  navState.setSearchQuery('');
                }
                navState.toggleSearch();
              },
            ),
            IconButton(
              icon: Image.asset(
                Assets.userIcon,
                height: 35.0,
                width: 35.0,
                fit: BoxFit.cover,
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
