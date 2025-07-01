import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/actor/actor_carousel.dart';
import 'package:app_m0v4u/ui/trailer_screen/views/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:share_plus/share_plus.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/tv_favorite_provider.dart';
import '../providers/tv_show_details_provider.dart';
import '../providers/tv_show_watchlist_provider.dart';

class TvShowDetailScreen extends StatefulWidget {
  final int tvShowId;

  const TvShowDetailScreen({super.key, required this.tvShowId});

  @override
  State<TvShowDetailScreen> createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isSuccess ? AppStyles.secondaryColor : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<TvShowDetailProvider>(context, listen: false).loadTvShow(widget.tvShowId);
      Provider.of<TvWatchlistProvider>(context, listen: false).fetchTvWatchlist(auth);
      Provider.of<TvFavoriteProvider>(context, listen: false).fetchTvFavorites(auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppStyles.primaryColor,
      appBar: const CustomNavBar(),
      drawer: const MenuDrawer(),
      body: Consumer3<TvShowDetailProvider, TvWatchlistProvider, TvFavoriteProvider>(
        builder: (context, tvProvider, watchlistProvider, favoriteProvider, _) {
          final auth = Provider.of<AuthProvider>(context, listen: false);

          if (tvProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tvShow = tvProvider.tvShow;
          if (tvShow == null) {
            return const Center(child: Text("TV Show not found."));
          }

          final isInWatchlist = watchlistProvider.isInWatchlist(tvShow.id);
          final isInFavorites = favoriteProvider.isInFavorites(tvShow.id);

          return Stack(
            children: [
              SizedBox(
                height: 380,
                width: double.infinity,
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${tvShow.backdropPath ?? tvShow.posterPath}',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.tv, color: Colors.white70, size: 50),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 300),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppStyles.primaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tvShow.name ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('${tvShow.voteAverage?.toStringAsFixed(1) ?? '0.0'}',
                              style: const TextStyle(color: Colors.black)),
                          const Icon(Icons.star, color: Colors.amber, size: 15),
                          const SizedBox(width: 12),
                          Text(tvShow.firstAirDate ?? '', style: const TextStyle(color: Colors.black26)),
                          const SizedBox(width: 12),
                          Text('${tvShow.episodeRunTime ?? 0} min/episode',
                              style: const TextStyle(color: Colors.black26)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: tvShow.genres
                            ?.map((g) => Chip(
                          label: Text(g['name'] ?? ''),
                          backgroundColor: const Color(0xFF4CAF50),
                          labelStyle: const TextStyle(color: Colors.white),
                        ))
                            .toList() ??
                            [],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: tvProvider.trailer != null
                                  ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => YouTubeScreen(
                                      videoId: tvProvider.trailer!.videoKey,
                                      title: tvProvider.trailer!.movieTitle,
                                    ),
                                  ),
                                );
                              }
                                  : null,
                              icon: Image.asset(
                                Assets.playIcon,
                                height: 20.0,
                                width: 20.0,
                              ),
                              label: const Text(
                                "Watch Trailer",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppStyles.secondaryColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () async {
                              if (auth.user == null || auth.sessionId == null) {
                                _showSnackBar(context, 'Please log in to manage your watchlist', false);
                                return;
                              }
                              await watchlistProvider.toggleTvWatchlist(
                                auth: auth,
                                tvShowId: tvShow.id,
                                add: !isInWatchlist,
                              );
                              _showSnackBar(
                                context,
                                isInWatchlist
                                    ? 'Removed from watchlist'
                                    : 'Added to watchlist',
                                true,
                              );
                            },
                            icon: Image.asset(
                              isInWatchlist ? Assets.watchList_filled : Assets.watchList_icon,
                              width: 30,
                              height: 30,
                              color: AppStyles.secondaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              final message = '''
📺 Check out this TV Show: ${tvShow.name}

🗓️ First Air Date: ${tvShow.firstAirDate ?? 'Unknown'}
⭐ Rating: ${tvShow.voteAverage?.toString() ?? 'N/A'} / 10
📄 Overview: ${tvShow.overview ?? 'No description available.'}

Powered by M0V4U
''';
                              final params = ShareParams(
                                text: message.trim(),
                                subject: 'Discover ${tvShow.name}',
                              );
                              SharePlus.instance.share(params);

                            },
                            icon: const Icon(Icons.share, color: AppStyles.secondaryColor),
                          ),
                          IconButton(
                            onPressed: () async {
                              if (auth.user == null || auth.sessionId == null) {
                                _showSnackBar(context, 'Please log in to manage your favorites', false);
                                return;
                              }
                              await favoriteProvider.toggleTvFavorite(
                                auth: auth,
                                tvShowId: tvShow.id,
                                add: !isInFavorites,
                              );
                              _showSnackBar(
                                context,
                                isInFavorites
                                    ? 'Removed from favorites'
                                    : 'Added to favorites',
                                true,
                              );
                            },
                            icon: Image.asset(
                              isInFavorites ? Assets.fullLove : Assets.emptyLove,
                              width: 30,
                              height: 30,
                              color: AppStyles.secondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tvShow.overview ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ActorCarousel(actors: tvProvider.actors),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
