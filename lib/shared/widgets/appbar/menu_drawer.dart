import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navState = Provider.of<NavBarState>(context, listen: false);

    return Drawer(
      backgroundColor: AppStyles.darkColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppStyles.secondaryColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.appLogoIcon,
                  height: 50.0,
                  width: 50.0,
                ),
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
            leading: Image.asset(
              Assets.homeAppbar,
              height: 30.0,
              width: 30.0,
            ),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              Assets.moviesAppbar,
              height: 30.0,
              width: 30.0,
            ),
            title: const Text('Movies', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              Assets.actorsAppbar,
              height: 30.0,
              width: 30.0,
            ),
            title:
                const Text('Actors', style: TextStyle(color: Colors.white)),
            onTap: () {
              navState.closeAll();
              Navigator.pop(context);
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: Image.asset(
                      Assets.trailersAppbar,
                      height: 30.0,
                      width: 30.0,
                    ),
            title:
                const Text('Trailers', style: TextStyle(color: Colors.white)),
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
