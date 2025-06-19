import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/shared/widgets/movie/movie_carousel.dart';
import 'package:app_m0v4u/ui/genre_screen/views/genre_screen.dart';
import 'package:app_m0v4u/ui/home_screen/providers/home_screen_provider.dart';
import 'package:app_m0v4u/ui/home_screen/views/actor_carousel_home.dart';
import 'package:app_m0v4u/ui/trailer_screen/views/trailer_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  bool get selectedLove => false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, home_provider, _) {
        if (home_provider.popularMovies.isEmpty &&
            home_provider.popularActors.isEmpty) {
          home_provider.fetchPopularMovies();
          home_provider.fetchPopularActors();
        }

        return Scaffold(
          backgroundColor: AppStyles.primaryColor,
          appBar: const CustomNavBar(),
          drawer: const MenuDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Skeletonizer(
                    enabled: home_provider.isLoading,
                    child: _buildHeaderSection(home_provider)),

                  const SizedBox(height: 16),
                  Skeletonizer(
                    enabled: home_provider.isLoading,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Popular Movies',
                        style: TextStyle(
                          color: AppStyles.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 16),

                  // Trending Movies List
                  home_provider.popularMovies.isNotEmpty
                      ? Skeletonizer(
                          enabled: home_provider.isLoading,
                          child: MovieCarousel(
                              movies: home_provider.popularMovies
                                  .take(10)
                                  .toList()),
                        )
                      : const Center(
                          child: Text(
                            'Aucun film tendance trouvé',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Skeletonizer(
                    enabled: home_provider.isLoading,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Browse Topics',
                        style: TextStyle(
                          color: AppStyles.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GenreGrid(),
                  const SizedBox(
                    height: 8,
                  ),
                  Skeletonizer(
                    enabled: home_provider.isLoading,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'Popular Actors',
                        style: TextStyle(
                          color: AppStyles.textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 16),

                  home_provider.popularActors.isNotEmpty
                      ? Skeletonizer(
                          enabled: home_provider.isLoading,
                          child: ActorHomeCarousel(
                              actors:
                                  home_provider.popularActors.take(7).toList()),
                        )
                      : const Center(
                          child: Text(
                            'Aucun film tendance trouvé',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                  const SizedBox(
                    height: 8,
                  ),

                  Skeletonizer(
                    enabled: home_provider.isLoading,
                    child: TrailerSelectorWidget()),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(HomeScreenProvider home_provider) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.welcomePic), // Replace with your image
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Million of films,actors and Series...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Search Section
            TextField(
              decoration: InputDecoration(
                hintText: 'Search films,actors..',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFfefeff),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    home_provider.setSearchQuery('');
                  },
                ),
              ),
              style: const TextStyle(color: AppStyles.textColor),
              onChanged: (value) {
                home_provider.searchMovies(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
