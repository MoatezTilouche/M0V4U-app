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

  const GenreMoviesScreen({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<GenreMoviesScreen> createState() => _GenreMoviesScreenState();
}

class _GenreMoviesScreenState extends State<GenreMoviesScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenreMoviesProvider>().fetchMoviesByGenre(widget.genreId);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<GenreMoviesProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoading &&
        provider.hasMorePages) {
      provider.fetchMoviesByGenre(widget.genreId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      appBar: const CustomNavBar(),
      body: Consumer<GenreMoviesProvider>(
        builder: (context, provider, _) {
          if (provider.genreMovies.isEmpty && !provider.isLoading) {
            return const Center(child: Text("No movies found for this genre", style: TextStyle(color: Colors.white70)));
          }

          final moviesToDisplay = provider.genreMovies;
          final hasMorePages = provider.hasMorePagesForGenre();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    'Browse Topics',
                    style: TextStyle(
                      color: AppStyles.textColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildGenreGrid(),
              const SizedBox(height: 4),
              Expanded(
                child: Skeletonizer(
                  enabled: provider.isLoading && moviesToDisplay.isEmpty,
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1 / 1.3,
                    ),
                    itemCount: moviesToDisplay.length + (hasMorePages && provider.isLoading ? 2 : 0),
                    itemBuilder: (context, index) {
                      if (index >= moviesToDisplay.length) {
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                        );
                      }
                      final movie = moviesToDisplay[index];
                      return GestureDetector(
                        onTap: () {
                          AnimatedNavigator.pushZoomIn(
                            context,
                            MovieDetailScreen(movieId: movie.id!),
                          );
                        },
                        child: Card(
                          color: AppStyles.cardColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 50, color: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                  height: 35,
                                  child: Center(
                                    child: Text(
                                      movie.title ?? "Unknown Title",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGenreGrid() {
    return Consumer<GenreScreenProvider>(builder: (context, genreProvider, _) {
      if (genreProvider.genres.isEmpty && !genreProvider.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          genreProvider.fetchGenres();
        });
      }

      return Skeletonizer(
        enabled: genreProvider.isLoading,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: genreProvider.genres.map((genre) {
              return _buildGenreItem(genre.id!, genre.name!, genre.icon!);
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildGenreItem(int genreId, String genreName, String genreIcon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          final provider = context.read<GenreMoviesProvider>();
          provider.resetGenreMovies(genreId);
          provider.fetchMoviesByGenre(genreId);
        },
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(genreIcon, height: 25, width: 25),
                  const SizedBox(height: 5),
                  Text(
                    genreName,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
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


  // Create Genre Grid inside GenreMoviesScreen

  // Build genre grid items (each genre)

  // Genre item for each genre

