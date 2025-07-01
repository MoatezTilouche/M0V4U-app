import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/ui/auth/views/request_token_screen.dart';
import 'package:app_m0v4u/ui/mainScreen/main_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../shared/widgets/animations/animation_navigator.dart';
import '../../movie_screen/providers/favorites_provider.dart';
import '../../movie_screen/providers/watchlist_provider.dart';
import '../../movie_screen/view/movie_screen.dart';
import '../../tv_show_screen/providers/tv_favorite_provider.dart';
import '../../tv_show_screen/providers/tv_show_watchlist_provider.dart';
import '../../tv_show_screen/views/tv_show_detail_screen.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _favoriteType = 'Movies'; // Default to Movies for favorites
  String _watchlistType = 'Movies'; // Default to Movies for watchlist

  @override
  void initState() {
    super.initState();
    // Fetch watchlist and favorites when the screen is initialized
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final watchlistProvider = Provider.of<WatchlistProvider>(context, listen: false);
    final favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    final tvWatchlistProvider = Provider.of<TvWatchlistProvider>(context, listen: false);
    final tvFavoriteProvider = Provider.of<TvFavoriteProvider>(context, listen: false);
    if (auth.user != null) {
      watchlistProvider.fetchWatchlist(auth);
      favoriteProvider.fetchFavorites(auth);
      tvWatchlistProvider.fetchTvWatchlist(auth);
      tvFavoriteProvider.fetchTvFavorites(auth);
    }
  }

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

  // Creates a skeleton placeholder for a favorite movie or TV show card
  Widget _buildFavoriteSkeletonCard() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: Colors.grey[300],
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 160,
            child: Container(
              height: 16,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 12,
            width: 40,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 8),
          Container(
            height: 20,
            width: 20,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Creates a skeleton placeholder for a watchlist item (movie or TV show)
  Widget _buildWatchlistSkeletonItem() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppStyles.secondaryColor.withOpacity(0.8),
              AppStyles.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 75,
              color: Colors.grey[300],
            ),
          ),
          title: Container(
            height: 16,
            width: 100,
            color: Colors.grey[300],
          ),
          subtitle: Container(
            height: 12,
            width: 40,
            color: Colors.grey[300],
          ),
          trailing: Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Builds the dropdown button for selecting content type
  Widget _buildDropdownButton(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  decoration: BoxDecoration(
  gradient: const LinearGradient(
  colors: [Color(0xFF26C6DA), Color(0xFF00C853)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  ),
  borderRadius: BorderRadius.circular(12),
  ),
      child: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: AppStyles.darkColor),
        items: ['Movies', 'TV Shows'].map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(
              type,
              style: const TextStyle(
                color: AppStyles.darkColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final TMDBUser? user = auth.user;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const GenerateRequestTokenScreen()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStyles.secondaryColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(Icons.person, size: 40, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.name?.isNotEmpty == true ? user.name! : user.username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${user.username}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.perm_identity, color: Colors.white38, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'TMDB ID: ${user.id}',
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text("Logout", style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          await auth.logout();
                          Provider.of<FavoriteProvider>(context, listen: false).clearFavorites();
                          Provider.of<WatchlistProvider>(context, listen: false).clearWatchlist();
                          Provider.of<TvFavoriteProvider>(context, listen: false).clearFavorites();
                          Provider.of<TvWatchlistProvider>(context, listen: false).clearWatchlist();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const MainScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Favorites Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Favorites',
                    style: TextStyle(
                      color: AppStyles.darkColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildDropdownButton(
                    _favoriteType,
                        (value) {
                      setState(() {
                        _favoriteType = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _favoriteType == 'Movies'
                  ? Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, _) {
                  return Skeletonizer(
                    enabled: favoriteProvider.isLoading,
                    child: favoriteProvider.isLoading
                        ? SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => _buildFavoriteSkeletonCard(),
                      ),
                    )
                        : Column(
                      children: [
                        if (favoriteProvider.error != null)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  favoriteProvider.error!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => favoriteProvider.fetchFavorites(auth),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        if (!favoriteProvider.isLoading &&
                            favoriteProvider.error == null &&
                            favoriteProvider.favorites.isEmpty)
                          const Center(
                            child: Text(
                              'Your favorite movies list is empty.',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        if (!favoriteProvider.isLoading &&
                            favoriteProvider.error == null &&
                            favoriteProvider.favorites.isNotEmpty)
                          SizedBox(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: favoriteProvider.favorites.length,
                              itemBuilder: (context, index) {
                                final movie = favoriteProvider.favorites[index];
                                return GestureDetector(
                                  onTap: () {
                                    AnimatedNavigator.pushZoomIn(
                                      context,
                                      MovieDetailScreen(movieId: movie['id']),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Skeleton.replace(
                                              replacement: Container(
                                                color: Colors.grey[300],
                                                child: const SizedBox.expand(),
                                              ),
                                              child: Image.network(
                                                'https://image.tmdb.org/t/p/w185${movie['poster_path']}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => const Icon(
                                                  Icons.movie,
                                                  color: Colors.white70,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            movie['title'] ?? 'Unknown Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppStyles.darkColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          movie['release_date']?.substring(0, 4) ?? 'N/A',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.redAccent, size: 20),
                                          onPressed: () async {
                                            await favoriteProvider.toggleFavorite(
                                              auth: auth,
                                              movieId: movie['id'],
                                              add: false,
                                            );
                                            if (favoriteProvider.error != null) {
                                              _showSnackBar(context, favoriteProvider.error!, false);
                                            } else {
                                              _showSnackBar(context, 'Removed from favorites', true);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              )
                  : Consumer<TvFavoriteProvider>(
                builder: (context, tvFavoriteProvider, _) {
                  return Skeletonizer(
                    enabled: tvFavoriteProvider.isLoading,
                    child: tvFavoriteProvider.isLoading
                        ? SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) => _buildFavoriteSkeletonCard(),
                      ),
                    )
                        : Column(
                      children: [
                        if (tvFavoriteProvider.error != null)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  tvFavoriteProvider.error!,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => tvFavoriteProvider.fetchTvFavorites(auth),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppStyles.secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        if (!tvFavoriteProvider.isLoading &&
                            tvFavoriteProvider.error == null &&
                            tvFavoriteProvider.favorites.isEmpty)
                          const Center(
                            child: Text(
                              'Your favorite TV shows list is empty.',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        if (!tvFavoriteProvider.isLoading &&
                            tvFavoriteProvider.error == null &&
                            tvFavoriteProvider.favorites.isNotEmpty)
                          SizedBox(
                            height: 260,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: tvFavoriteProvider.favorites.length,
                              itemBuilder: (context, index) {
                                final tv = tvFavoriteProvider.favorites[index];
                                return GestureDetector(
                                  onTap: () {
                                    AnimatedNavigator.pushZoomIn(
                                      context,
                                      TvShowDetailScreen(tvShowId: tv['id']),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    margin: const EdgeInsets.only(right: 12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Skeleton.replace(
                                              replacement: Container(
                                                color: Colors.grey[300],
                                                child: const SizedBox.expand(),
                                              ),
                                              child: Image.network(
                                                'https://image.tmdb.org/t/p/w185${tv['poster_path']}',
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => const Icon(
                                                  Icons.tv,
                                                  color: Colors.white70,
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 160,
                                          child: Text(
                                            tv['name'] ?? 'Unknown Title',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppStyles.darkColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tv['first_air_date']?.substring(0, 4) ?? 'N/A',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.redAccent, size: 20),
                                          onPressed: () async {
                                            await tvFavoriteProvider.toggleTvFavorite(
                                              auth: auth,
                                              tvShowId: tv['id'],
                                              add: false,
                                            );
                                            if (tvFavoriteProvider.error != null) {
                                              _showSnackBar(context, tvFavoriteProvider.error!, false);
                                            } else {
                                              _showSnackBar(context, 'Removed from favorites', true);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              // Watchlist Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Watchlist',
                    style: TextStyle(
                      color: AppStyles.darkColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildDropdownButton(
                    _watchlistType,
                        (value) {
                      setState(() {
                        _watchlistType = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _watchlistType == 'Movies'
                  ? Consumer<WatchlistProvider>(
                builder: (context, watchlistProvider, _) {
                  return Skeletonizer(
                    enabled: watchlistProvider.isLoading,
                    child: watchlistProvider.isLoading
                        ? Column(
                      children: List.generate(
                        3,
                            (_) => _buildWatchlistSkeletonItem(),
                      ),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                            child: Text(
                              'Your watchlist is empty.',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppStyles.primaryColor,
                                          Color(0xFFf8f9fb)
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
                      children: List.generate(
                        3,
                            (_) => _buildWatchlistSkeletonItem(),
                      ),
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
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                            child: Text(
                              'Your TV show watchlist is empty.',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppStyles.primaryColor,
                                          Color(0xFFf8f9fb)
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}