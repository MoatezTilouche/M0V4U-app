// lib/ui/home_screen/models/movie_model.dart

class Movie {
  final String originalTitle;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final DateTime releaseDate;

  Movie({
    required this.originalTitle,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
    required this.releaseDate,
  });

  // Factory method to create a Movie object from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      originalTitle: json['original_title'] as String,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String,
      overview: json['overview'] as String,
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: DateTime.parse(json['release_date'] as String),
    );
  }
}
