import 'package:app_m0v4u/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui/auth/models/user.dart';

class TMDBAuthService {
  static const String _apiKey = apiKey;
  static const String _baseUrl = baseUrl;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    queryParameters: {'api_key': _apiKey},
    headers: {'Content-Type': 'application/json'},
  ));

  /// Step 1: Create request token
  Future<String?> createRequestToken() async {
    try {
      final res = await _dio.get('/authentication/token/new');
      if (res.data['success'] == true) {
        return res.data['request_token'];
      }
      throw Exception('Failed to create request token: ${res.data['status_message']}');
    } on DioException catch (e) {
      print("❌ Failed to create request token: ${e.response?.data}");
      throw Exception('Failed to create request token: ${e.response?.data['status_message'] ?? e.message}');
    }
  }

  /// Step 2: Open browser to approve token
  Future<bool> launchBrowserToApprove(String requestToken) async {
    final url = 'https://www.themoviedb.org/authenticate/$requestToken';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("❌ Could not launch $url");
      throw Exception('Could not launch approval URL');
    }
  }

  /// Step 3: Create session
  Future<String?> createSession(String requestToken) async {
    try {
      final res = await _dio.post(
        '/authentication/session/new',
        data: {'request_token': requestToken},
      );
      if (res.data['success'] == true) {
        return res.data['session_id'];
      }
      throw Exception('Failed to create session: ${res.data['status_message']}');
    } on DioException catch (e) {
      print("❌ Failed to create session: ${e.response?.data}");
      throw Exception('Failed to create session: ${e.response?.data['status_message'] ?? e.message}');
    }
  }

  /// Step 4: Get user details
  Future<TMDBUser?> getUserDetails(String sessionId) async {
    try {
      final res = await _dio.get(
        '/account',
        queryParameters: {'session_id': sessionId},
      );
      if (res.data['id'] != null) {
        return TMDBUser.fromJson(res.data);
      }
      throw Exception('Failed to fetch user details: Invalid response');
    } on DioException catch (e) {
      print("❌ getUserDetails: ${e.response?.data}");
      throw Exception('Failed to fetch user details: ${e.response?.data['status_message'] ?? e.message}');
    }
  }
}