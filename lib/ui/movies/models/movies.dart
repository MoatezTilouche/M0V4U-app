class Movies {
  int? page;
  List<Result>? results;
  int? totalPages;
  int? totalResults;

  Movies({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      page: json['page'],
      results: (json['results'] as List)
          .map((movieJson) => Result.fromJson(movieJson))
          .toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'results': results?.map((e) => e.toJson()).toList(),
        'total_pages': totalPages,
        'total_results': totalResults,
      };
}

class Result {
  int? id;
  String? posterPath;
  String? title;
  double? popularity;

  Result({
    this.id,
    this.posterPath,
    this.title,
    this.popularity,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
      popularity: json['popularity']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'poster_path': posterPath,
        'title': title,
        'popularity': popularity,
      };
}
