import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/actor/models/actor.dart';
import 'package:dio/dio.dart';
import '../ui/home_screen/models/movie_model.dart';

class ActorService {
  final Dio _dio = Dio();
 
  Future<Actor> fetchActorDetails(int personId) async {
    final response = await _dio.get(
      '$baseUrl/person/$personId',
      queryParameters: {
        'api_key': apiKey,
        'language': 'fr',
      },
    );

    if (response.statusCode == 200) {
      return Actor.fromJson(response.data);
    } else {
      throw Exception('Failed to load actor details');
    }
  }

  Future<List<Movie>> fetchActorMovies(int personId) async {
    final response = await _dio.get(
      '$baseUrl/person/$personId/movie_credits',
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> castList = response.data['cast'] ?? [];
      return castList
          .map((json) => Movie.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load actor movie credits');
    }
  }
}