import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:dio/dio.dart';
import 'package:app_m0v4u/constants/constants.dart';

import '../ui/trailer_screen/models/trailer_model.dart';
import '../ui/tv_show_screen/models/tv_show.dart';


class TvShowDetailService {
  final Dio _dio = Dio();

  Future<TvShow> fetchTvShowDetails(int tvShowId) async {
    final response = await _dio.get(
      '$baseUrl/tv/$tvShowId',
      queryParameters: {'api_key': apiKey, 'language': 'en-US'},
    );

    if (response.statusCode == 200) {
      return TvShow.fromJson(response.data);
    } else {
      throw Exception('Failed to load TV show details');
    }
  }

  Future<List<Actor>> fetchTvShowActors(int tvShowId) async {
    final response = await _dio.get(
      '$baseUrl/tv/$tvShowId/credits',
      queryParameters: {'api_key': apiKey},
    );

    if (response.statusCode == 200) {
      final List castJson = response.data['cast'] ?? [];
      return castJson.take(10).map((e) => Actor.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch actors');
    }
  }

  Future<Trailer?> fetchFirstYouTubeTrailer(int tvShowId, String name) async {
    try {
      final response = await _dio.get(
        '$baseUrl/tv/$tvShowId/videos',
        queryParameters: {'api_key': apiKey},
      );

      final results = response.data['results'] as List;
      final ytTrailer = results.firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
        orElse: () => null,
      );

      if (ytTrailer != null) {
        return Trailer.fromJson(ytTrailer, name);
      }
      return null;
    } catch (e) {
      print("Failed to fetch trailer: $e");
      return null;
    }
  }
}
