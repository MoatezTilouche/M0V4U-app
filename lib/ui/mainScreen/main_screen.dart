import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/bottomBar/bottom_bar.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/views/chat_bot_screen.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/views/widgets/chat_bot_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:app_m0v4u/ui/actor_screen/views/actors_screen.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:app_m0v4u/ui/movies/movies_screen/movies_screen.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the selected tab
  late PageController _pageController;

  final List<Widget> _screens = <Widget>[
    HomeScreen(), // Home Screen
    ActorsScreen(), // Actors Screen
    ChatBotContentWidget(),
    MoviesScreen(),
    ChatBotContentWidget(),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      extendBody: false,
      resizeToAvoidBottomInset: true,
      appBar: const CustomNavBar(isBackButtonShown: false,),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: AppBottomBar(
        icons: [
          Assets.homeAppbar,
          Assets.actorsAppbar,
          Assets.chatBot,
          Assets.moviesAppbar,
          Assets.userIcon,
        ],
        defaultSelectedIndex: _selectedIndex,
        onItemClicked: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
