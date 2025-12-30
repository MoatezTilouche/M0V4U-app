import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/actor/actor_carousel.dart';
import 'package:app_m0v4u/ui/trailer_screen/views/youtube_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/movie_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/watchlist_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  MovieDetailScreen({super.key, required this.movieId});

  // Shows a SnackBar with the given message and success status
  void _showSnackBar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: isSuccess ? AppStyles.secondaryColor : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieDetailProvider()..loadMovie(movieId)),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()..fetchWatchlist(Provider.of<AuthProvider>(context, listen: false))),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()..fetchFavorites(Provider.of<AuthProvider>(context, listen: false))),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppStyles.primaryColor,
        appBar: const CustomNavBar(),
        drawer: const MenuDrawer(),
        body: Consumer3<MovieDetailProvider, WatchlistProvider, FavoriteProvider>(
          builder: (context, movieProvider, watchlistProvider, favoriteProvider, _) {
            final auth = Provider.of<AuthProvider>(context, listen: false);

            if (movieProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final movie = movieProvider.movie;
            if (movie == null) {
              return const Center(child: Text("Movie not found."));
            }

            final isInWatchlist = watchlistProvider.isInWatchlist(movie.id!);
            final isInFavorites = favoriteProvider.isInFavorites(movie.id!);

            return Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.backdropPath ?? movie.posterPath}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.movie,
                      color: Colors.white70,
                      size: 50,
                    ),
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
                          movie.title ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${movie.voteAverage?.toStringAsFixed(1) ?? '0.0'}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Icon(Icons.star, color: Colors.amber, size: 15),
                            const SizedBox(width: 12),
                            Text(
                              '${movie.runtime ?? 0} min',
                              style: const TextStyle(color: Colors.black26),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${movie.releaseDate?.year ?? ''}',
                              style: const TextStyle(color: Colors.black26),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: movie.genres?.map((g) => Chip(
                            label: Text(g.name ?? ''),
                            backgroundColor: const Color(0xFF4CAF50),
                            labelStyle: const TextStyle(color: Colors.white),
                          )).toList() ??
                              [],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: movieProvider.trailer != null
                                    ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => YouTubeScreen(
                                        videoId: movieProvider.trailer!.videoKey,
                                        title: movieProvider.trailer!.movieTitle,
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
                                await watchlistProvider.toggleWatchlist(
                                  auth: auth,
                                  movieId: movie.id!,
                                  add: !isInWatchlist,
                                );
                                if (watchlistProvider.error != null) {
                                  _showSnackBar(context, watchlistProvider.error!, false);
                                } else {
                                  _showSnackBar(
                                    context,
                                    isInWatchlist
                                        ? 'Removed from watchlist'
                                        : 'Added to watchlist',
                                    true,
                                  );
                                }
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
                                🎬 Check out this movie: ${movie.title}
                                
                                🗓️ Release Date: ${movie.releaseDate?.year ?? 'Unknown'}
                                ⭐ Rating: ${movie.voteAverage?.toString() ?? 'N/A'} / 10
                                📄 Overview: ${movie.overview ?? 'No description available.'}
                                
                                Powered by M0V4U
                                ''';

                                final params = ShareParams(
                                  text: message.trim(),
                                  subject: 'Discover ${movie.title}',
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
                                await favoriteProvider.toggleFavorite(
                                  auth: auth,
                                  movieId: movie.id!,
                                  add: !isInFavorites,
                                );
                                if (favoriteProvider.error != null) {
                                  _showSnackBar(context, favoriteProvider.error!, false);
                                } else {
                                  _showSnackBar(
                                    context,
                                    isInFavorites
                                        ? 'Removed from favorites'
                                        : 'Added to favorites',
                                    true,
                                  );
                                }
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
                        if (movie.productionCompanies != null)
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: movie.productionCompanies!.length,
                              itemBuilder: (context, index) {
                                final company = movie.productionCompanies![index];
                                return Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: company.logoPath != null
                                            ? NetworkImage(
                                          'https://image.tmdb.org/t/p/w200${company.logoPath}',
                                        )
                                            : null,
                                        radius: 30,
                                        backgroundColor: AppStyles.primaryColor,
                                        child: company.logoPath == null
                                            ? const Icon(Icons.business, color: Colors.white70)
                                            : null,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        company.name ?? '',
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          movie.overview ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black26,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ActorCarousel(actors: movieProvider.actors),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}