import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/ui/auth/views/request_token_screen.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/favorite_list.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/profile_card.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/profile_details.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/recommendation_list.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../movie_screen/providers/favorites_provider.dart';
import '../../movie_screen/providers/watchlist_provider.dart';
import '../../tv_show_screen/providers/tv_favorite_provider.dart';
import '../../tv_show_screen/providers/tv_show_watchlist_provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/watch_list.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _favoriteType = 'Movies';
  String _watchlistType = 'Movies';
  String _recommendationType = 'Movies';

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(context, listen: false);
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    final tvWatchlistProvider = Provider.of<TvWatchlistProvider>(context, listen: false);
    final tvFavoriteProvider = Provider.of<TvFavoriteProvider>(context, listen: false);
    if (auth.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await watchlistProvider.fetchWatchlist(auth);
        await favoriteProvider.fetchFavorites(auth);
        await tvWatchlistProvider.fetchTvWatchlist(auth);
        await tvFavoriteProvider.fetchTvFavorites(auth);

        await favoriteProvider.fetchRecommendations();
        await tvFavoriteProvider.fetchRecommendations();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: CustomNavBar(),
      backgroundColor: AppStyles.primaryColor,
      body: auth.user == null
          ? const GenerateRequestTokenScreen()
          : ProfileDetails(auth: auth),
    );
  }
}







