import 'package:intl/intl.dart';

class Movie {
  final int id;
  final String originalTitle;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final DateTime releaseDate;
  final List<String> genres;

  Movie({
    required this.id,
    required this.originalTitle,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> parsedGenres = [];

    if (json['genre_ids'] is List) {
      parsedGenres = (json['genre_ids'] as List)
          .whereType<int>()
          .map((id) => Movie.genreMap[id] ?? 'Unknown')
          .toList();
    }

    return Movie(
      id: json['id'],
      originalTitle: json['original_title'] ?? '',
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime(2000),
      genres: parsedGenres,
    );
  }

  String get formattedReleaseDate {
    return DateFormat('d MMMM y').format(releaseDate);
  }

  static const Map<int, String> genreMap = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Sci-Fi',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };
}
