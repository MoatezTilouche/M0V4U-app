import 'package:app_m0v4u/ui/genre_screen/model/genre_model.dart';
import 'package:app_m0v4u/ui/genre_screen/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../movies_acc_to_genres/views/movies_by_genre_screen.dart';

class GenreGrid extends StatelessWidget {
  const GenreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreScreenProvider>(builder: (context, genreProvider, _) {
      if (genreProvider.genres.isEmpty) {

          WidgetsBinding.instance.addPostFrameCallback((_) {

            genreProvider.fetchGenres();

          });

      }

      return Skeletonizer(
        enabled: genreProvider.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenreGrid(genreProvider.genres,context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  // Build the genre grid
  Widget _buildGenreGrid(List<Genre> genres,BuildContext context) {
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
                return _buildGenreItem(genre.id, genre.name, genre.icon,context);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Genre item card displaying the genre icon and name
  Widget _buildGenreItem(int genreId, String genreName, String genreIcon,
      BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Use context here safely for navigation
              Navigator.push(
                context, // This context is now properly passed
                MaterialPageRoute(
                  builder: (_) =>
                      GenreMoviesScreen(
                        genreId: genreId, // genreId is required
                        genreName: genreName, // genreName is required
                      ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              width: 100,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    genreIcon, // genreIcon for each genre
                    height: 32.0,
                    width: 32.0,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    genreName, // genreName for each genre
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}