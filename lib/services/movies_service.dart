import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/movies/models/movies.dart';
import 'package:dio/dio.dart';

import '../ui/home_screen/models/movie_model.dart';

class MoviesService {
  final Dio _dio = Dio();
  final String _apiKey = apiKey;  // Replace with your API key
  final String _baseUrl = baseUrl;  // Replace with your API base URL

  // Fetch popular movies
  Future<List<Result>> getPopularMovies(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/movie/popular', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching popular movies');
    }
  }

  // Fetch top rated movies
  Future<List<Result>> getTopRatedMovies(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/movie/top_rated', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching top rated movies');
    }
  }

  // Fetch upcoming movies
  Future<List<Result>> getUpcomingMovies(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/movie/upcoming', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching upcoming movies');
    }
  }

  // Fetch now playing movies
  Future<List<Result>> getNowPlayingMovies(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/movie/now_playing', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load now playing movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching now playing movies');
    }
  }
  Future<List<Result>> searchMovies(String query, int page) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'language': 'en-US',
          'query': query,
          'page': page,
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response: ${response.data}');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error searching movies');
    }
  }


}
