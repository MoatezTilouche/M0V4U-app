import 'package:app_m0v4u/constants/styles.dart';
import 'package:flutter/material.dart';

import '../../../constants/assets.dart';
import '../../../ui/actor_screen/views/actors_screen.dart';
import '../../../ui/home_screen/views/home_screen.dart';
import '../../../ui/movies/movies_screen/movies_screen.dart';


class AppBottomAppBar extends StatefulWidget {
  const AppBottomAppBar({
    Key? key,
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.scaffoldKey,
    required this.selectedIndex,
  }) : super(key: key);

  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int selectedIndex;

  @override
  _AppBottomAppBarState createState() => _AppBottomAppBarState();
}

class _AppBottomAppBarState extends State<AppBottomAppBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _showAddFavoriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: AddFavoriteForm(), // Placeholder for a form to add favorite actor/movie
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: widget.shape,
      color: Colors.white,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Home Tab
            _buildTabItem(
              index: 0,
              icon: const ImageIcon(AssetImage(Assets.homeAppbar)), // Replace with your asset
              text: 'Home',
              navigateTo:  HomeScreen(), // Replace with your HomeScreen
            ),
            const Spacer(),
            // Actors Tab
            _buildTabItem(
              index: 1,
              icon: const ImageIcon(AssetImage(Assets.actorsAppbar)), // Replace with your asset
              text: 'Actors',
              navigateTo:  ActorsScreen(),
            ),
            const Spacer(),
            // Add Favorite Tab (FAB-like action)
            _buildTabItem(
              index: 1,
              icon: const ImageIcon(AssetImage(Assets.chatBot),size: 30,), // Replace with your asset
              text: 'Bot',
              navigateTo:  ActorsScreen(),
            ),
            const Spacer(),
            // Movies Tab
            _buildTabItem(
              index: 3,
              icon: const ImageIcon(AssetImage(Assets.moviesAppbar)), // Replace with your asset
              text: 'Movies',
              navigateTo: MoviesScreen(), // Replace with your MoviesScreen
            ),
            const Spacer(),
            // Profile Tab
            _buildTabItem(
              index: 4,
              icon: const ImageIcon(AssetImage(Assets.userIcon)), // Replace with your asset
              text: 'Profile',
              navigateTo: const ProfileScreen(), // Replace with your ProfileScreen
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required Widget icon,
    required String text,
    Widget? navigateTo,
    VoidCallback? onTap,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (onTap != null) {
          onTap();
        } else if (navigateTo != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => navigateTo),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: isSelected ? AppStyles.secondaryColor : Colors.grey,
            ),
            child: icon,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? AppStyles.secondaryColor : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for the Add Favorite Form dialog
class AddFavoriteForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Favorite Actor/Movie',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Name or Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement save favorite logic (e.g., call API or provider)
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Profile')));
}