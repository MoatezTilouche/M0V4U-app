import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../services/movies_acc_to_genres.dart';
import '../../../constants/styles.dart';
import '../../../shared/widgets/appbar/custom_navbar.dart';
import '../../../shared/widgets/animations/animation_navigator.dart';
import '../../../ui/movie_screen/view/movie_screen.dart';
import '../../genre_screen/model/genre_model.dart';
import '../../genre_screen/providers/genre_provider.dart';
import '../providers/movies_by_genre_provider.dart';

class GenreMoviesScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreMoviesScreen({super.key, required this.genreId, required this.genreName});

  @override
  _GenreMoviesScreenState createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Fetch movies by genre initially
    Provider.of<GenreMoviesProvider>(context, listen: false).fetchMoviesByGenre(widget.genreId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: CustomNavBar(),
      body: Consumer<GenreMoviesProvider>(builder: (context, provider, _) {
        // Check if the provider has any movies and display loading skeleton if needed
        if (provider.genreMovies.isEmpty && !provider.isLoading) {
          return Center(child: Text("No movies found for this genre"));
        }

        List<Result> moviesToDisplay = provider.genreMovies;
        bool hasMorePages = provider.hasMorePagesForGenre();

        return Column(
          children: [
            Padding(
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
            // Genre Grid for selection
            _buildGenreGrid(),
            const SizedBox(height: 3),
            Expanded(  // Wrap GridView with Expanded
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1 / 1.3,
                ),
                itemCount: moviesToDisplay.length + (hasMorePages && provider.isLoading ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= moviesToDisplay.length) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    );
                  }

                  final movie = moviesToDisplay[index];
                  return Card(
                    color: AppStyles.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: GestureDetector(
                      onTap: () {
                        AnimatedNavigator.pushZoomIn(
                            context, MovieDetailScreen(movieId: movie.id!));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              width: double.infinity,
                              height: 160,
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 160,
                                  color: Colors.grey[300],
                                  child: Icon(Icons.movie_filter, size: 50, color: Colors.grey[600]),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: Center(
                                child: Text(
                                  movie.title ?? "Unknown Title",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // Create Genre Grid inside GenreMoviesScreen
  Widget _buildGenreGrid() {
    return Consumer<GenreScreenProvider>(builder: (context, genreProvider, _) {
      if (genreProvider.genres.isEmpty) {
        genreProvider.fetchGenres();
      }

      return Skeletonizer(
        enabled: genreProvider.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenreGridItems(genreProvider.genres),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }

  // Build genre grid items (each genre)
  Widget _buildGenreGridItems(List<Genre> genres) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: genres.map((genre) {
                return _buildGenreItem(genre.id!, genre.name!, genre.icon!);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Genre item for each genre
  Widget _buildGenreItem(int genreId, String genreName, String genreIcon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: GestureDetector(
        onTap: () {
          // Change the genreId and genreName dynamically and fetch movies
          Provider.of<GenreMoviesProvider>(context, listen: false).resetGenreMovies(genreId);
          Provider.of<GenreMoviesProvider>(context, listen: false)
              .fetchMoviesByGenre(genreId);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: 90,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    genreIcon,
                    height: 25.0,
                    width: 25.0,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    genreName,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
