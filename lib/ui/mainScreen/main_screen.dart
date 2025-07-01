import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/bottomBar/bottom_bar.dart';
import 'package:app_m0v4u/ui/auth/views/request_token_screen.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/profile_details.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/views/widgets/chat_bot_content_widget.dart';
import 'package:app_m0v4u/ui/actor_screen/views/actors_screen.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:app_m0v4u/ui/movies/movies_screen/movies_screen.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/ui/tv_shows_screen/views/tv_shows_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/ui/auth/providers/auth_provider.dart';

import '../auth/models/user.dart';
import '../auth/views/profil_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Track the selected tab
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final TMDBUser? user = auth.user;

    // Define the screens list, conditionally setting the last screen
    final List<Widget> _screens = <Widget>[
       HomeScreen(),
       ActorsScreen(),
       ChatBotContentWidget(),
       MoviesScreen(),
      TvShowsScreen(),
      user != null ?  ProfileDetails(auth: auth) :  GenerateRequestTokenScreen(),
    ];

    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      extendBody: false,
      resizeToAvoidBottomInset: true,
      appBar: const CustomNavBar(
        isBackButtonShown: false,
      ),
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
          Assets.tvShows_icon,
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