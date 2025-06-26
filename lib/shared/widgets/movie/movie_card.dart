import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/ui/movie_screen/view/movie_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool selectedLove;
  final VoidCallback? onFavoriteTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.selectedLove = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    print('Genres for ${movie.title}: ${movie.genres}');

    return GestureDetector(
      onTap: () {
        AnimatedNavigator.pushZoomIn(
          context,
          MovieDetailScreen(movieId: movie.id),
        );
        print("Navigating to detail for movie ID: ${movie.id}");
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                height: 260,
                width: 230,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: onFavoriteTap,
                child: Image.asset(
                  selectedLove ? Assets.fullLove : Assets.emptyLove,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      AppStyles.secondaryColor,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Center(
                      child: Wrap(
                        spacing: 6,
                        children: movie.genres.take(2).map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF2196F3), // Bleu (haut)
                                  Color(0xFF4CAF50), // Vert (bas)
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
