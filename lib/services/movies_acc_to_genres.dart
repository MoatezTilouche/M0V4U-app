import 'package:dio/dio.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import 'package:app_m0v4u/constants/constants.dart';

class GenreMoviesService {
  final Dio _dio = Dio();
  final String _apiKey = apiKey;
  final String _baseUrl = baseUrl;

  Future<List<Result>> getMoviesByGenre(int genreId, int page) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/discover/movie',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'en-US',
          'with_genres': genreId,
          'page': page,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load movies for genre');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching movies for genre');
    }
  }
}
