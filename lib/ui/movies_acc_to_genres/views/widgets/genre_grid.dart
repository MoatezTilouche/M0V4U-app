import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../genre_screen/providers/genre_provider.dart';
import 'genre_item.dart';

class GenreGrid extends StatefulWidget {
  const GenreGrid({super.key});

  @override
  State<GenreGrid> createState() => _GenreGridState();
}

class _GenreGridState extends State<GenreGrid> {
  @override
  Widget build(BuildContext context) {
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
              return GenreItem(
                  genreId:genre.id!,
                  genreName:genre.name!,
                  genreIcon:genre.icon!);
            }).toList(),
          ),
        ),
      );
    });

  }
}
