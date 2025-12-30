import 'package:app_m0v4u/constants/constants.dart';

class AppUrl {
  //https://api.themoviedb.org/3/movie/popular?api_key=0277cc714ad9100fe38b7f37fdfeb1d9
  //https://api.themoviedb.org/3/movie/550?api_key=0277cc714ad9100fe38b7f37fdfeb1d9
  //https://api.themoviedb.org/3/person/

  static const photoBaseUrl = "https://image.tmdb.org/t/p/w500";

  static const moviesBaseUrl = 'https://api.themoviedb.org/3/movie';

  static const personBaseUrl = 'https://api.themoviedb.org/3/person';
  static const moviesPopularMovie = '$moviesBaseUrl/popular?api_key=$apiKey';
  static const moviesUpComingMovie = '$moviesBaseUrl/upcoming?api_key=$apiKey';
  static const moviesTopRatedMovie = '$moviesBaseUrl/top_rated?api_key=$apiKey';

  static const cast = '/credits?api_key=$apiKey';

//https://api.themoviedb.org/3/movie/16/videos?api_key=0277cc714ad9100fe38b7f37fdfeb1d9

  static const movieVideo = '/videos?api_key=$apiKey';

//https://api.themoviedb.org/3/movie/{movie_id}/similar?api_key=<<api_key>>&language=en-US&page=1

  static const similarMovie = '/similar?api_key=$apiKey';

//https://api.themoviedb.org/3/movie/16/reviews?api_key=0277cc714ad9100fe38b7f37fdfeb1d9
  static const reviewMovie = '/reviews?api_key=$apiKey';

//https://api.themoviedb.org/3/person/504?api_key=0277cc714ad9100fe38b7f37fdfeb1d9
  static const personDetail = '?api_key=$apiKey';

  //https://api.themoviedb.org/3/person/504/movie_credits?api_key=0277cc714ad9100fe38b7f37fdfeb1d9

  static const movieCredits = '/movie_credits?api_key=$apiKey';

  //https://api.themoviedb.org/3/person/504/images?api_key=0277cc714ad9100fe38b7f37fdfeb1d9

  static const personImage = '/images?api_key=$apiKey';
}
