import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/actor/models/actor.dart';
import 'package:app_m0v4u/ui/home_screen/models/movie_model.dart';
import 'package:dio/dio.dart';

class ActorService {
  final Dio _dio;

  ActorService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    queryParameters: {'api_key': apiKey},
  )) {
    // Add logging interceptor for debugging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Actor> fetchActorDetails(int personId) async {
    try {
      final response = await _dio.get(
        '/person/$personId',
        queryParameters: {
          'language': 'en-US', // Consistent language
        },
      );

      if (response.statusCode == 200) {
        return Actor.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load actor details: ${response.statusCode} ${response.data['status_message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'fetch actor details');
    } catch (e) {
      print('Unexpected error fetching actor details: $e');
      throw Exception('Failed to fetch actor details: $e');
    }
  }

  Future<List<Movie>> fetchActorMovies(int personId) async {
    try {
      final response = await _dio.get(
        '/person/$personId/movie_credits',
        queryParameters: {
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> castList = response.data['cast'] ?? [];
        return castList.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load actor movie credits: ${response.statusCode} ${response.data['status_message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'fetch actor movie credits');
    } catch (e) {
      print('Unexpected error fetching actor movies: $e');
      throw Exception('Failed to fetch actor movies: $e');
    }
  }

  Future<List<Actor>> getPopularActors(int page) async {
    try {
      final response = await _dio.get(
        '/person/popular',
        queryParameters: {
          'language': 'en-US',
          'page': page,
        },
      );

      print('Popular Actors Response: ${response.data}'); // Detailed logging

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.map((actor) => Actor.fromJson(actor)).toList();
      } else {
        throw Exception(
            'Failed to load popular actors: ${response.statusCode} ${response.data['status_message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'fetch popular actors');
    } catch (e) {
      print('Unexpected error fetching popular actors: $e');
      throw Exception('Failed to fetch popular actors: $e');
    }
  }

  Future<List<Actor>> searchActors(String query, int page) async {
    try {
      final response = await _dio.get(
        '/search/person',
        queryParameters: {
          'language': 'en-US',
          'query': query,
          'page': page,
        },
      );

      print('Search Actors Response: ${response.data}'); // Detailed logging

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'] ?? [];
        return data.map((actorJson) => Actor.fromJson(actorJson)).toList();
      } else {
        throw Exception(
            'Failed to search actors: ${response.statusCode} ${response.data['status_message'] ?? response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e, 'search actors');
    } catch (e) {
      print('Unexpected error searching actors: $e');
      throw Exception('Failed to search actors: $e');
    }
  }

  // Helper method to handle Dio exceptions
  Exception _handleDioException(DioException e, String operation) {
    String errorMessage = 'Failed to $operation';
    if (e.response != null) {
      errorMessage +=
      ': ${e.response!.statusCode} ${e.response!.data['status_message'] ?? e.response!.statusMessage}';
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage += ': Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage += ': Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage += ': Receive timeout';
          break;
        case DioExceptionType.connectionError:
          errorMessage += ': No internet connection';
          break;
        case DioExceptionType.cancel:
          errorMessage += ': Request cancelled';
          break;
        case DioExceptionType.badResponse:
          errorMessage += ': Bad response';
          break;
        case DioExceptionType.badCertificate:
          errorMessage += ': Bad certificate';
          break;
        case DioExceptionType.unknown:
          errorMessage += ': ${e.message ?? 'Unknown error'}';
          break;
      }
    }
    print('DioException during $operation: $errorMessage');
    return Exception(errorMessage);
  }
}