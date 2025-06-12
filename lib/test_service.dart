import 'package:app_m0v4u/model.dart';
import 'package:dio/dio.dart';

class TMDBService {
  final Dio _dio = Dio();
  final String _apiKey = 'e7e9d3be2fd4de2754fb8700716a4c82';  
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _dio.get('$_baseUrl/movie/popular', queryParameters: {
        'api_key': _apiKey,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['results'];
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des films populaires');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  
}

