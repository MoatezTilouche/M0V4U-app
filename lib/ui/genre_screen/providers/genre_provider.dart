import 'package:app_m0v4u/services/genre_mov_services.dart';
import 'package:app_m0v4u/ui/genre_screen/model/genre_model.dart';
import 'package:flutter/material.dart';

class GenreScreenProvider with ChangeNotifier {
  final GenreService _genreService = GenreService();

  List<Genre> specificGenres = [];
  List<Genre> otherGenres = [];
  List<Genre> genres = [];

  bool isLoading = false;

  Future<void> fetchGenres() async {
    isLoading = true;
    notifyListeners();

    try {
      final genresData = await _genreService.getMovieGenres();

      // Assign the fetched lists to their respective fields
      specificGenres = genresData['specificGenres']!;
      otherGenres = genresData['otherGenres']!;

      // Concatenate the lists and update the genres list
      genres = specificGenres + otherGenres;
    } catch (e) {
      print('Error fetching genres: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}
