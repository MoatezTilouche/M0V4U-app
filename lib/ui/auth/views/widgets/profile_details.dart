import 'package:app_m0v4u/ui/auth/providers/auth_provider.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/favorite_list.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/profile_card.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/recommendation_list.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/section_header.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/watch_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../movie_screen/providers/favorites_provider.dart';
import '../../../movie_screen/providers/watchlist_provider.dart';
import '../../../tv_show_screen/providers/tv_favorite_provider.dart';
import '../../../tv_show_screen/providers/tv_show_watchlist_provider.dart';

class ProfileDetails extends StatefulWidget {
  final AuthProvider auth;

  const ProfileDetails({super.key, required this.auth});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  String _favoriteType = 'Movies';
  String _watchlistType = 'Movies';
  String _recommendationType = 'Movies';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = widget.auth;

      if (auth.user != null) {
        final watchlistProvider = context.read<WatchlistProvider>();
        final favoriteProvider = context.read<FavoriteProvider>();
        final tvWatchlistProvider = context.read<TvWatchlistProvider>();
        final tvFavoriteProvider = context.read<TvFavoriteProvider>();

        await watchlistProvider.fetchWatchlist(auth);
        await favoriteProvider.fetchFavorites(auth);
        await tvWatchlistProvider.fetchTvWatchlist(auth);
        await tvFavoriteProvider.fetchTvFavorites(auth);

        await favoriteProvider.fetchRecommendations();
        await tvFavoriteProvider.fetchRecommendations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(auth: widget.auth),
            const SizedBox(height: 32),
            SectionHeader(
              title: 'My Favorites',
              value: _favoriteType,
              onChanged: (value) => setState(() => _favoriteType = value!),
            ),
            const SizedBox(height: 16),
            FavoriteList(type: _favoriteType, auth: widget.auth),
            const SizedBox(height: 32),
            SectionHeader(
              title: 'My Watchlist',
              value: _watchlistType,
              onChanged: (value) => setState(() => _watchlistType = value!),
            ),
            const SizedBox(height: 16),
            WatchlistList(type: _watchlistType, auth: widget.auth),
            const SizedBox(height: 32),
            SectionHeader(
              title: 'Recommendations For You',
              value: _recommendationType,
              onChanged: (value) => setState(() => _recommendationType = value!),
            ),
            const SizedBox(height: 16),
            RecommendationList(type: _recommendationType, auth: widget.auth),
          ],
        ),
      ),
    );
  }
}
