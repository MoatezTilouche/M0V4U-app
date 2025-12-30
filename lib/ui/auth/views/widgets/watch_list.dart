import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/auth/providers/auth_provider.dart';
import 'package:app_m0v4u/ui/auth/views/profil_screen.dart';
import 'package:app_m0v4u/ui/auth/views/widgets/skeleton_list_item.dart';
import 'package:app_m0v4u/ui/movie_screen/providers/watchlist_provider.dart';
import 'package:app_m0v4u/ui/movie_screen/view/movie_screen.dart';
import 'package:app_m0v4u/ui/tv_show_screen/providers/tv_show_watchlist_provider.dart';
import 'package:app_m0v4u/ui/tv_show_screen/views/tv_show_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../constants/assets.dart';

class WatchlistList extends StatelessWidget {
  final String type;
  final AuthProvider auth;

  const WatchlistList({super.key, required this.type, required this.auth});

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
  Widget build(BuildContext context) {
    return type == 'Movies'
        ? Consumer<WatchlistProvider>(
      builder: (context, watchlistProvider, _) {
        return Skeletonizer(
          enabled: watchlistProvider.isLoading,
          child: watchlistProvider.isLoading
              ? Column(
            children: List.generate(3, (_) => const SkeletonListItem()),
          )
              : Column(
            children: [
              if (watchlistProvider.error != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        watchlistProvider.error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => watchlistProvider.fetchWatchlist(auth),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.secondaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              if (!watchlistProvider.isLoading &&
                  watchlistProvider.error == null &&
                  watchlistProvider.watchlist.isEmpty)
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     ImageIcon( AssetImage(Assets.watchList_icon)),
                      const SizedBox(width: 15,),
                      Text(
                        'Your watchlist is empty.',
                        style: TextStyle(color: AppStyles.darkColor, fontSize: 16,fontWeight: FontWeight.bold ),
                      ),
                    ],
                  ),
                ),
              if (!watchlistProvider.isLoading &&
                  watchlistProvider.error == null &&
                  watchlistProvider.watchlist.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: watchlistProvider.watchlist.length,
                  itemBuilder: (context, index) {
                    final movie = watchlistProvider.watchlist[index];
                    return GestureDetector(
                      onTap: () {
                        AnimatedNavigator.pushZoomIn(
                          context,
                          MovieDetailScreen(movieId: movie['id']),
                        );
                        print("Navigating to detail for movie ID: ${movie['id']}");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppStyles.primaryColor,
                                Color(0xfff6f6f6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: movie['poster_path'] != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Skeleton.replace(
                                replacement: Container(
                                  width: 50,
                                  height: 75,
                                  color: Colors.grey[300],
                                ),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.movie, color: Colors.white70),
                                ),
                              ),
                            )
                                : const Icon(Icons.movie, color: Colors.white70),
                            title: Text(
                              movie['title'] ?? 'Unknown Title',
                              style: const TextStyle(
                                color: AppStyles.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              movie['release_date']?.substring(0, 4) ?? 'N/A',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                              onPressed: () async {
                                await watchlistProvider.toggleWatchlist(
                                  auth: auth,
                                  movieId: movie['id'],
                                  add: false,
                                );
                                if (watchlistProvider.error != null) {
                                  _showSnackBar(context, watchlistProvider.error!, false);
                                } else {
                                  _showSnackBar(context, 'Removed from watchlist', true);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    )
        : Consumer<TvWatchlistProvider>(
      builder: (context, tvWatchlistProvider, _) {
        return Skeletonizer(
          enabled: tvWatchlistProvider.isLoading,
          child: tvWatchlistProvider.isLoading
              ? Column(
            children: List.generate(3, (_) => const SkeletonListItem()),
          )
              : Column(
            children: [
              if (tvWatchlistProvider.error != null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        tvWatchlistProvider.error!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => tvWatchlistProvider.fetchTvWatchlist(auth),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyles.secondaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              if (!tvWatchlistProvider.isLoading &&
                  tvWatchlistProvider.error == null &&
                  tvWatchlistProvider.watchlist.isEmpty)
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon( AssetImage(Assets.watchList_icon)),
                      const SizedBox(width: 15,),
                      Text(
                        'Your watchlist is empty.',
                        style: TextStyle(color: AppStyles.darkColor, fontSize: 16,fontWeight: FontWeight.bold ),
                      ),
                    ],
                  ),
                ),
              if (!tvWatchlistProvider.isLoading &&
                  tvWatchlistProvider.error == null &&
                  tvWatchlistProvider.watchlist.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tvWatchlistProvider.watchlist.length,
                  itemBuilder: (context, index) {
                    final tv = tvWatchlistProvider.watchlist[index];
                    return GestureDetector(
                      onTap: () {
                        AnimatedNavigator.pushZoomIn(
                          context,
                          TvShowDetailScreen(tvShowId: tv['id']),
                        );
                        print("Navigating to detail for TV show ID: ${tv['id']}");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppStyles.primaryColor,
                                Color(0xfff6f6f6)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: tv['poster_path'] != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Skeleton.replace(
                                replacement: Container(
                                  width: 50,
                                  height: 75,
                                  color: Colors.grey[300],
                                ),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w92${tv['poster_path']}',
                                  width: 50,
                                  height: 75,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.tv,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            )
                                : const Icon(Icons.tv, color: Colors.white70),
                            title: Text(
                              tv['name'] ?? 'Unknown Title',
                              style: const TextStyle(
                                color: AppStyles.darkColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              tv['first_air_date']?.substring(0, 4) ?? 'N/A',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle, color: Colors.redAccent),
                              onPressed: () async {
                                await tvWatchlistProvider.toggleTvWatchlist(
                                  auth: auth,
                                  tvShowId: tv['id'],
                                  add: false,
                                );
                                if (tvWatchlistProvider.error != null) {
                                  _showSnackBar(context, tvWatchlistProvider.error!, false);
                                } else {
                                  _showSnackBar(context, 'Removed from watchlist', true);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
