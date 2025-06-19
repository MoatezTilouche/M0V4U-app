import 'package:app_m0v4u/constants/assets.dart'; 
import 'package:app_m0v4u/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:app_m0v4u/ui/genre_screen/model/genre_model.dart';

class GenreService {
  final Dio _dio = Dio();

  // Fetch genres and return two separate lists
  Future<Map<String, List<Genre>>> getMovieGenres() async {
    try {
      final response = await _dio.get(
        '$baseUrl/genre/movie/list',
        queryParameters: {
          'api_key': apiKey, // API Key
          'language': 'en-US',
        },
      );

      print('Status code: ${response.statusCode}'); 

      if (response.statusCode == 200) {
        List<dynamic> genresData = response.data['genres'];
        
        // Filter the genres into specific genres and others
        List<Genre> specificGenres = [];
        List<Genre> otherGenres = [];

        for (var genre in genresData) {
          Genre newGenre = Genre(
            id: genre['id'],
            name: genre['name'],
            icon: _getIconForGenre(genre['id']),
          );

         
            // Add to specific genres if the genre is one of the predefined types
            if (_isSpecificGenre(newGenre.id)) {
              specificGenres.add(newGenre);
            } else {
              otherGenres.add(newGenre);
            }
          
        }

        // Return a map containing both lists
        return {
          'specificGenres': specificGenres,
          'otherGenres': otherGenres,
        };
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      print('Error fetching genres: $e');
      throw Exception('Error fetching genres');
    }
  }

  // Helper function to check if the genre is one of the specific genres
  bool _isSpecificGenre(int id) {
    const specificGenreIds = [
      12,   // Adventure
      35,   // Comedy
      80,   // Crime
      27,   // Horror
      10749,// Romance
      10402 // Music
    ];

    return specificGenreIds.contains(id);
  }

  // Map genre IDs to asset icons
  String _getIconForGenre(int id) {
    switch (id) {
      case 12: // Adventure
        return Assets.adventure;
      case 35: // Comedy
        return Assets.comedy;
      case 80: // Crime
        return Assets.crime;
     
      case 27: // Horror
        return Assets.horror;
      case 10749: // Romance
        return Assets.romance;
        case 10402: // Music
        return Assets.music;  
      default:
        return Assets.pLusIcon; // Default icon for others
    }
  }
}
