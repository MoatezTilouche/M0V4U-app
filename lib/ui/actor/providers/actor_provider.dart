import 'package:flutter/material.dart';
import '../../../services/actor_service.dart';
import '../models/actor.dart';
import '../../home_screen/models/movie_model.dart';

class ActorProvider extends ChangeNotifier {
  final ActorService _actorService = ActorService();

  Actor? _actor;
  List<Movie> _movies = [];
  bool _isLoading = false;

  Actor? get actor => _actor;
  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> loadActor(int personId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _actor = await _actorService.fetchActorDetails(personId);
      _movies = await _actorService.fetchActorMovies(personId);
    } catch (e) {
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}