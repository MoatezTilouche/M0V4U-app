import 'package:app_m0v4u/ui/genre_screen/model/genre_model.dart';
import 'package:app_m0v4u/ui/genre_screen/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GenreGrid extends StatelessWidget {
  const GenreGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreScreenProvider>(builder: (context, genreProvider, _) {
      if (genreProvider.genres.isEmpty) {
        genreProvider.fetchGenres();
      }

      return Skeletonizer(
        enabled: genreProvider.isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGenreGrid(genreProvider.genres),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  // Build the genre grid
  Widget _buildGenreGrid(List<Genre> genres) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Wrapping GridView in a SingleChildScrollView to prevent overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Make it scrollable horizontally
            child: Row(
              children: genres.map((genre) {
                return _buildGenreItem(genre.name, genre.icon);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Genre item card displaying the genre icon and name
  Widget _buildGenreItem(String genreName, String genreIcon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                  genreIcon,
                  height: 32.0,
                  width: 32.0,
                ),
                const SizedBox(height: 5),
                Text(
                  genreName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
