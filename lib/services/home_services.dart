import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:app_m0v4u/ui/movie_screen/models/movie.dart' hide Movie;
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

      print(response.data);

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

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response =
          await _dio.get('$_baseUrl/search/movie', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'query': query,
        'page': 1,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        print(response.data);
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error searching movies');
    }
  }

 Future<List<Actor>> getPopularActors() async {
    try {
      final response =
          await _dio.get('$_baseUrl/person/popular', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': 1,
      });

      print(response.data);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((actor) => Actor.fromJson(actor)).toList();
      } else {
        throw Exception('Failed to load popular actors');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching popular actors');
    }
  }
}
