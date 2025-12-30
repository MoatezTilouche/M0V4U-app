class Trailer {
  final String title;          // Trailer title
  final String videoKey;       // YouTube video key
  final String thumbnailUrl;   // YouTube thumbnail
  final String movieTitle;     // Title of the movie this trailer is for

  Trailer({
    required this.title,
    required this.videoKey,
    required this.movieTitle,
  }) : thumbnailUrl = 'https://img.youtube.com/vi/$videoKey/0.jpg';

  factory Trailer.fromJson(Map<String, dynamic> json, String movieTitle) {
    return Trailer(
      title: json['name'] ?? 'Trailer',
      videoKey: json['key'] ?? '',
      movieTitle: movieTitle,
    );
  }
}
