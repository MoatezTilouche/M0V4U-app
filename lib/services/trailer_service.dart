import 'package:dio/dio.dart';
import 'package:app_m0v4u/constants/constants.dart';
import 'package:app_m0v4u/ui/trailer_screen/models/trailer_model.dart';

class TrailerService {
  final Dio _dio = Dio();

  Future<List<Trailer>> fetchTrailers(String category) async {
    try {
      final movieRes = await _dio.get(
        '$baseUrl/movie/$category',
        queryParameters: {'api_key': apiKey},
      );

      final List results = movieRes.data['results'];
      final List<Trailer> trailers = [];

      for (var movie in results.take(10)) {
        final movieTitle = movie['title'];
        final movieId = movie['id'];

        final videoRes = await _dio.get(
          '$baseUrl/movie/$movieId/videos',
          queryParameters: {'api_key': apiKey},
        );

        final List videos = videoRes.data['results'];
        final ytTrailer = videos.firstWhere(
          (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
          orElse: () => null,
        );

        if (ytTrailer != null) {
          trailers.add(Trailer.fromJson(ytTrailer, movieTitle));
        }
      }

      return trailers;
    } catch (e) {
      throw Exception('Failed to fetch trailers: $e');
    }
  }
}
