import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:flutter/material.dart';
import '../../../services/tv_show_details_service.dart';
import '../models/tv_show.dart';
import '../../trailer_screen/models/trailer_model.dart';

class TvShowDetailProvider with ChangeNotifier {
  final TvShowDetailService _service = TvShowDetailService();

  TvShow? _tvShow;
  List<Actor> _actors = [];
  bool _isLoading = false;
  Trailer? _trailer;

  TvShow? get tvShow => _tvShow;
  List<Actor> get actors => _actors;
  bool get isLoading => _isLoading;
  Trailer? get trailer => _trailer;

  Future<void> loadTvShow(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tvShow = await _service.fetchTvShowDetails(id);
      _actors = await _service.fetchTvShowActors(id);
      _trailer =
      await _service.fetchFirstYouTubeTrailer(id, _tvShow?.name ?? '');
    } catch (e) {
      print("Error loading TV show or actors: $e");
      _tvShow = null;
      _actors = [];
      _trailer = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
