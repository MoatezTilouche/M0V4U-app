class TvShow {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double? voteAverage;
  final List<dynamic>? genres;
  final int? numberOfSeasons;
  final String? firstAirDate;
  final int? episodeRunTime;

  TvShow({
    required this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage,
    this.genres,
    this.numberOfSeasons,
    this.firstAirDate,
    this.episodeRunTime,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] != null)
          ? json['vote_average'].toDouble()
          : null,
      genres: json['genres'],
      numberOfSeasons: json['number_of_seasons'],
      firstAirDate: json['first_air_date'],
      episodeRunTime: (json['episode_run_time'] != null &&
          (json['episode_run_time'] as List).isNotEmpty)
          ? (json['episode_run_time'][0] as int?)
          : null,
    );
  }
}
