import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:dio/dio.dart';

class MovieService {
  final Dio _dio = Dio();
  final String _apiKey = apiKey;
  final String _baseUrl = baseUrl;

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response =
          await _dio.get('$_baseUrl/movie/popular', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': 1, 
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching popular movies');
    }
  }
}
