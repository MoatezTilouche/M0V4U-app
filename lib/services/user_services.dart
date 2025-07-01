import 'package:dio/dio.dart';
import '../../constants/constants.dart';

class UserService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json;charset=utf-8',
      },
    ),
  );

  /// Adds or removes a movie from the user's watchlist.
  Future<bool> addToWatchlist({
    required int accountId,
    required String sessionId,
    required int movieId,
    bool watchlist = true,
  }) async {
    try {
      final response = await _dio.post(
        '/account/$accountId/watchlist',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'watchlist': watchlist,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding to watchlist: $e');
      return false;
    }
  }

  /// Removes a movie from the user's watchlist.
  Future<bool> removeFromWatchlist({
    required int accountId,
    required String sessionId,
    required int movieId,
  }) async {
    return await addToWatchlist(
      accountId: accountId,
      sessionId: sessionId,
      movieId: movieId,
      watchlist: false,
    );
  }

  /// Fetches the user's watchlist movies.
  Future<List<Map<String, dynamic>>> getWatchlist({
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get(
        '/account/$accountId/watchlist/movies',
        queryParameters: {
          'session_id': sessionId,
          'sort_by': 'created_at.desc',
        },
      );
      return (response.data['results'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      print('Error fetching watchlist: $e');
      return [];
    }
  }

  /// Adds or removes a movie from the user's favorites.
  Future<bool> addToFavorite({
    required int accountId,
    required String sessionId,
    required int movieId,
    bool favorite = true,
  }) async {
    try {
      final response = await _dio.post(
        '/account/$accountId/favorite',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': favorite,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  /// Fetches the user's favorite movies.
  Future<List<Map<String, dynamic>>> getFavoriteMovies({
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get(
        '/account/$accountId/favorite/movies',
        queryParameters: {
          'session_id': sessionId,
          'sort_by': 'created_at.desc',
        },
      );
      return (response.data['results'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      print('Error fetching favorite movies: $e');
      return [];
    }
  }

  /// Adds or removes a TV show from the user's watchlist.
  Future<bool> addTvShowToWatchlist({
    required int accountId,
    required String sessionId,
    required int tvShowId,
    bool watchlist = true,
  }) async {
    try {
      final response = await _dio.post(
        '/account/$accountId/watchlist',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'tv',
          'media_id': tvShowId,
          'watchlist': watchlist,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding TV show to watchlist: $e');
      return false;
    }
  }

  /// Fetch the user's TV watchlist
  Future<List<Map<String, dynamic>>> getTvWatchlist({
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get(
        '/account/$accountId/watchlist/tv',
        queryParameters: {
          'session_id': sessionId,
          'sort_by': 'created_at.desc',
        },
      );
      return (response.data['results'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      print('Error fetching TV watchlist: $e');
      return [];
    }
  }

  /// Adds or removes a TV show from the user's favorites.
  Future<bool> addTvShowToFavorite({
    required int accountId,
    required String sessionId,
    required int tvShowId,
    bool favorite = true,
  }) async {
    try {
      final response = await _dio.post(
        '/account/$accountId/favorite',
        queryParameters: {'session_id': sessionId},
        data: {
          'media_type': 'tv',
          'media_id': tvShowId,
          'favorite': favorite,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error adding TV show to favorites: $e');
      return false;
    }
  }

  /// Fetch the user's favorite TV shows
  Future<List<Map<String, dynamic>>> getFavoriteTvShows({
    required int accountId,
    required String sessionId,
  }) async {
    try {
      final response = await _dio.get(
        '/account/$accountId/favorite/tv',
        queryParameters: {
          'session_id': sessionId,
          'sort_by': 'created_at.desc',
        },
      );
      return (response.data['results'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      print('Error fetching favorite TV shows: $e');
      return [];
    }
  }

}