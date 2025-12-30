import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart';
import 'package:app_m0v4u/ui/trailer_screen/models/trailer_model.dart';
import 'package:dio/dio.dart';

class MovieDetailService {
  final Dio _dio = Dio();

  Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await _dio.get(
      '$baseUrl/movie/$movieId',
      queryParameters: {'api_key': apiKey, 'language': 'en-US'},
    );

    print('API status: ${response.statusCode}');
    print('API response: ${response.data}');

    if (response.statusCode == 200) {
      return Movie.fromJson(response.data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Actor>> fetchMovieActors(int movieId) async {
    final response = await _dio.get(
      '$baseUrl/movie/$movieId/credits',
      queryParameters: {'api_key': apiKey},
    );

    if (response.statusCode == 200) {
      final List castJson = response.data['cast'] ?? [];
      return castJson.take(10).map((e) => Actor.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch actors');
    }
  }

  Future<bool> hasTrailer(int movieId) async {
    final response = await _dio.get(
      '$baseUrl/movie/$movieId/videos',
      queryParameters: {'api_key': apiKey},
    );

    if (response.statusCode == 200) {
      final List videos = response.data['results'] ?? [];
      return videos.any(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
      );
    } else {
      throw Exception('Failed to check for trailers');
    }
  }

  Future<Trailer?> fetchFirstYouTubeTrailer(
      int movieId, String movieTitle) async {
    try {
      final response = await _dio.get(
        '$baseUrl/movie/$movieId/videos',
        queryParameters: {'api_key': apiKey},
      );

      final results = response.data['results'] as List;

      final ytTrailer = results.firstWhere(
        (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
        orElse: () => null,
      );

      if (ytTrailer != null) {
        return Trailer.fromJson(ytTrailer, movieTitle);
      }
      return null;
    } catch (e) {
      print("Failed to fetch trailer: $e");
      return null;
    }
  }
}
