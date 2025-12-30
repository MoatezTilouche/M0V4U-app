import 'package:app_m0v4u/services/movie_detail_service.dart';
import 'package:app_m0v4u/ui/trailer_screen/models/trailer_model.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailProvider with ChangeNotifier {
  final MovieDetailService _service = MovieDetailService();

  Movie? _movie;
  List<Actor> _actors = [];
  bool _isLoading = false;
  bool _hasTrailer = false;
  Trailer? _trailer;

  Movie? get movie => _movie;
  List<Actor> get actors => _actors;
  bool get isLoading => _isLoading;
  bool get hasTrailer => _hasTrailer;
  Trailer? get trailer => _trailer;

  Future<void> loadMovie(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _movie = await _service.fetchMovieDetails(id);
      _actors = await _service.fetchMovieActors(id);
      _trailer =
          await _service.fetchFirstYouTubeTrailer(id, _movie?.title ?? '');
    } catch (e) {
      print("Error loading movie or actors: $e");
      _movie = null;
      _actors = [];
      _trailer = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
