import 'package:app_m0v4u/constants/constants.dart';
import 'package:dio/dio.dart';

import '../ui/tv_shows_screen/models/tv_shows.dart';


class TvShowsService {
  final Dio _dio = Dio();
  final String _apiKey = apiKey;  // Replace with your API key
  final String _baseUrl = baseUrl;  // Replace with your API base URL

  // Fetch popular movies
  Future<List<Result>> getPopularTvShows(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/tv/popular', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load popular Tv Series');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching popular Tv Series');
    }
  }

  // Fetch top rated movies
  Future<List<Result>> getTopRatedTvShows(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/tv/top_rated', queryParameters: {
        'api_key': _apiKey,
        'language': 'en-US',
        'page': page,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movieJson) => Result.fromJson(movieJson)).toList();
      } else {
        throw Exception('Failed to load top rated tv shows');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error fetching top rated tv shows');
    }
  }

  // Fetch upcoming movies
  Future<List<Result>> getUpcomingTvShows(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/tv/airing_today', queryParameters: {
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
  Future<List<Result>> getNowPlayingTvShows(int page) async {
    try {
      final response = await _dio.get('$_baseUrl/tv/on_the_air', queryParameters: {
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
  Future<List<Result>> searchTvShows(String query, int page) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search/tv',
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
        throw Exception('Failed to search Tv Shows');
      }
    } catch (e) {
      print("Error: $e");
      throw Exception('Error searching Tv Shows');
    }
  }


}
