import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/movies_by_genre_provider.dart';

class GenreItem extends StatefulWidget {
  final int genreId;
  final String genreName;
  final String genreIcon;
  const GenreItem({super.key, required this.genreId, required this.genreName, required this.genreIcon});

  @override
  State<GenreItem> createState() => _GenreItemState();
}

class _GenreItemState extends State<GenreItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          final provider = context.read<GenreMoviesProvider>();
          provider.resetGenreMovies(widget.genreId);
          provider.fetchMoviesByGenre(widget.genreId);
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
                  Image.asset(widget.genreIcon, height: 25, width: 25),
                  const SizedBox(height: 5),
                  Text(
                    widget.genreName,
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
