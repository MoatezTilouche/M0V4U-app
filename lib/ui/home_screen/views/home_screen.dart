import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/appbar/custom_navbar.dart';
import 'package:app_m0v4u/shared/widgets/appbar/menu_drawer.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:app_m0v4u/ui/home_screen/providers/home_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, home_provider, _) {
        if (home_provider.popularMovies.isEmpty) {
          home_provider.fetchPopularMovies();
        }

        return Scaffold(
          backgroundColor: AppStyles.secondaryColor,
          appBar: const CustomNavBar(),
          drawer: const MenuDrawer(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  _buildHeaderSection(),

                  const SizedBox(height: 24),

                  // Trending Movies Section
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Popular Movies',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 16),

                  // Trending Movies List
                  home_provider.popularMovies.isNotEmpty
                      ? _buildTrendingMoviesList(home_provider)
                      : const Center(
                          child: Text(
                            'Aucun film tendance trouvé',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendingMoviesList(HomeScreenProvider home_provider) {
    final List<Movie> movies = home_provider.popularMovies;

    final List<Movie> displayedMovies = movies.take(7).toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(displayedMovies.length, (index) {
              final movie = displayedMovies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildMovieCard(movie),
              );
            }),
          ),
        ),
        if (movies.length > 7)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  // Action to show more movies
                  // You can handle the "show more" functionality here, e.g., by navigating or loading more items
                },
              ),
            ),
          ),
      ],
    );
  }

  // Movie Card - Each movie displayed inside a card with rounded corners
  Widget _buildMovieCard(Movie movie) {
    return Card(
      color: const Color(0xFF112155),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      elevation: 5,
      child: Container(
        width: 150, // Set card width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: movie.posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      width: 150,
                      height: 225,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 8),
            Text(
              movie.originalTitle,
              style: const TextStyle(
                color: AppStyles.primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Rating: ${movie.voteAverage}',
              style: const TextStyle(
                color: AppStyles.primaryColor,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Release Date: ${movie.releaseDate.toLocal()}',
              style: const TextStyle(
                color: AppStyles.primaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeaderSection() {
  return Container(
    width: double.infinity,
    height: 250,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(Assets.welcomePic),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Des millions de films, émissions télévisées et artistes...',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Search Section
          TextField(
            decoration: InputDecoration(
              hintText: 'Recherche...',
              hintStyle: const TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () {
                  // Reset the search query
                },
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              // Update search query
            },
          ),
        ],
      ),
    ),
  );
}
